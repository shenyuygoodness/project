import 'package:flutter/material.dart';
import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/controller/services/firestore_service.dart';
import 'package:project/app/model/lesson_model.dart';
import 'package:project/app/view/details_screens/lesson_details_screens.dart';
// import 'lesson_detail_screen.dart';

class LessonsListScreen extends StatefulWidget {
  const LessonsListScreen({super.key});

  @override
  State<LessonsListScreen> createState() => _LessonsListScreenState();
}

class _LessonsListScreenState extends State<LessonsListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _searchController = TextEditingController();
  
  List<LessonModel> allLessons = [];
  List<LessonModel> filteredLessons = [];
  bool isLoading = true;
  String selectedDifficulty = 'all';
  // String selectedRiskLevel = 'all';
  String selectedThreatType = 'all';

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLessons() async {
    try {
      setState(() {
        isLoading = true;
      });

      final lessons = await _firebaseService.getAllLessons();
      setState(() {
        allLessons = lessons;
        filteredLessons = lessons;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading lessons: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterLessons() {
    setState(() {
      filteredLessons = allLessons.where((lesson) {
        final matchesSearch = _searchController.text.isEmpty ||
            lesson.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            lesson.content.toLowerCase().contains(_searchController.text.toLowerCase());

        final matchesDifficulty = selectedDifficulty == 'all' || 
            lesson.difficulty == selectedDifficulty;

        // final matchesRiskLevel = selectedRiskLevel == 'all' || 
        //     lesson.riskLevel == selectedRiskLevel;

        final matchesThreatType = selectedThreatType == 'all' || 
            lesson.threatType == selectedThreatType;

        return matchesSearch && matchesDifficulty && matchesThreatType;
      }).toList();
    });
  }

  void _navigateToLessonDetail(LessonModel lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(lesson: lesson),
      ),
    );
  }

  Future<void> _deleteLesson(LessonModel lesson) async {
    try {
      await _firebaseService.deleteLesson(lesson.id!);
      await _loadLessons();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting lesson: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(LessonModel lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D3E50),
        title: const Text(
          'Delete Lesson',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${lesson.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLesson(lesson);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A252F),
      appBar: AppBar(
        title: const Text(
          'Cybersecurity Lessons',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A252F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadLessons,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterLessons(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search lessons...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white60),
                        onPressed: () {
                          _searchController.clear();
                          _filterLessons();
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF2D3E50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Difficulty', selectedDifficulty, [
                    'all', 'beginner', 'intermediate', 'advanced'
                  ], (value) {
                    setState(() {
                      selectedDifficulty = value;
                    });
                    _filterLessons();
                  }),
                  // const SizedBox(width: 8.0),
                  // _buildFilterChip('Risk Level', selectedRiskLevel, [
                  //   'all', 'low', 'medium', 'high'
                  // ], (value) {
                  //   setState(() {
                  //     selectedRiskLevel = value;
                  //   });
                  //   _filterLessons();
                  // }),
                  const SizedBox(width: 8.0),
                  _buildFilterChip('Threat Type', selectedThreatType, [
                    'all', 'malware', 'phishing', 'domain', 'ip', 'url'
                  ], (value) {
                    setState(() {
                      selectedThreatType = value;
                    });
                    _filterLessons();
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          // Lessons List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : filteredLessons.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              color: Colors.white60,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No lessons found',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Generate lessons from threat intelligence data',
                              style: TextStyle(
                                // color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Generate Lessons',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 12.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: filteredLessons.length,
                        itemBuilder: (context, index) {
                          final lesson = filteredLessons[index];
                          return _buildLessonCard(lesson);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, List<String> options, Function(String) onChanged) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (context) {
        return options.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(
              option == 'all' ? 'All ${label}s' : option.toUpperCase(),
              style: TextStyle(
                color: selectedValue == option ? Colors.blue : Colors.white,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3E50),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: selectedValue != 'all' ? Colors.blue : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ${selectedValue == 'all' ? 'All' : selectedValue.toUpperCase()}',
              style: TextStyle(
                color: selectedValue != 'all' ? Colors.blue : Colors.white,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              Icons.arrow_drop_down,
              color: selectedValue != 'all' ? Colors.blue : Colors.white,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(LessonModel lesson) {
    return Card(
      color: const Color(0xFF2D3E50),
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => _navigateToLessonDetail(lesson),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(lesson);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8.0),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              // Summary
              Text(
                lesson.summary,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14.0,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12.0),

              // Tags
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(lesson.difficulty),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      lesson.difficulty.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _getRiskColor(lesson.riskLevel),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      lesson.riskLevel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      lesson.threatType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created ${_formatDate(lesson.createdAt)}',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12.0,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Colors.white60,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${lesson.keyPoints.length} key points',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}