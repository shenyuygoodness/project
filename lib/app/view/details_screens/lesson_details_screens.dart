// import 'package:flutter/material.dart';

// class LessonDetailsScreens extends StatefulWidget {
//   const LessonDetailsScreens({super.key});

//   @override
//   State<LessonDetailsScreens> createState() => _LessonDetailsScreensState();
// }

// class _LessonDetailsScreensState extends State<LessonDetailsScreens> {
//   final List<Map<String, String>> _content = [
//     {'section': 'Introduction', 'text': 'Malware, short for malicious software, encompasses various forms of harmful programs designed to infiltrate and damage computer systems. These programs can range from viruses and worms to Trojans and ransomware, each with unique characteristics and methods of operation. Understanding the different types of malware and their potential impact is crucial for effective cybersecurity.'},
//     {'section': 'Prevention', 'text': 'Viruses are self-replicating programs that attach themselves to legitimate files, spreading when the infected file is executed. Worms, on the other hand, are standalone programs that can replicate and spread across networks without requiring a host file. Trojans disguise themselves as harmless software but contain malicious code that can be activated once installed.'},
//     {'section': 'Mitigation', 'text': 'Ransomware encrypts a victim\'s files and demands payment for their release. The consequences of malware infections can be severe, ranging from data loss and system instability to financial theft and reputational damage.'},
//     {'section': 'Control', 'text': 'Organizations and individuals alike must implement robust security measures, such as antivirus software, firewalls, and regular software updates, to mitigate the risk of malware attacks. Additionally, user awareness and education play a vital role in preventing infections, as many malware programs rely on social engineering tactics to trick users into downloading or executing malicious files.'},
//     {'section': 'Conclusion', 'text': ''},
//   ];

//   String _feedback = 'True';

//   void _setFeedback(String value) {
//     setState(() {
//       _feedback = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A252F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A252F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Understanding Malware',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _content.length,
//                 itemBuilder: (context, index) {
//                   final item = _content[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item['section']!,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           item['text']!,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Was the content above helpful?',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text('True', style: TextStyle(color: Colors.white)),
//                     value: 'True',
//                     groupValue: _feedback,
//                     onChanged: (value) => _setFeedback(value!),
//                     activeColor: Colors.blue,
//                     tileColor: const Color(0xFF2D3E50),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text('False', style: TextStyle(color: Colors.white)),
//                     value: 'False',
//                     groupValue: _feedback,
//                     onChanged: (value) => _setFeedback(value!),
//                     activeColor: Colors.blue,
//                     tileColor: const Color(0xFF2D3E50),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: Handle feedback submission
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 child: const Text(
//                   'Done',
//                   style: TextStyle(color: Colors.white, fontSize: 16.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:project/app/model/lesson_model.dart';
import 'package:project/app/controller/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonModel lesson;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final FirebaseService _firebaseService = FirebaseService();
  bool isExpanded = false;
  String expandedSection = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSection(String section) {
    setState(() {
      if (expandedSection == section) {
        expandedSection = '';
      } else {
        expandedSection = section;
      }
    });
  }

  Future<void> _deleteLesson() async {
    try {
      await _firebaseService.deleteLesson(widget.lesson.id!);
      if (mounted) {
        Navigator.pop(context);
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D3E50),
        title: const Text(
          'Delete Lesson',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.lesson.title}"?',
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
              _deleteLesson();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _shareLesson() async {
    // You can implement sharing functionality here
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A252F),
      appBar: AppBar(
        title: const Text(
          'Lesson Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A252F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareLesson,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation();
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
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                _buildHeaderCard(),
                const SizedBox(height: 16.0),
                
                // Content Section
                _buildContentSection(),
                const SizedBox(height: 16.0),
                
                // Key Points Section
                _buildKeyPointsSection(),
                const SizedBox(height: 16.0),
                
                // Prevention Steps Section
                _buildPreventionSection(),
                const SizedBox(height: 16.0),
                
                // Detection Methods Section
                _buildDetectionSection(),
                const SizedBox(height: 16.0),
                
                // Metadata Section
                _buildMetadataSection(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      color: const Color(0xFF2D3E50),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12.0),
            
            // Summary
            Text(
              widget.lesson.summary,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15.0,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16.0),
            
            // Tags Row
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildTag(
                  widget.lesson.difficulty.toUpperCase(),
                  _getDifficultyColor(widget.lesson.difficulty),
                  Icons.school,
                ),
                _buildTag(
                  widget.lesson.riskLevel.toUpperCase(),
                  _getRiskColor(widget.lesson.riskLevel),
                  Icons.warning,
                ),
                _buildTag(
                  widget.lesson.threatType.toUpperCase(),
                  Colors.blue.withOpacity(0.8),
                  Icons.security,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14.0),
          const SizedBox(width: 4.0),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return _buildExpandableSection(
      title: 'Lesson Content',
      icon: Icons.article,
      content: widget.lesson.content,
      sectionKey: 'content',
      color: Colors.green.withOpacity(0.8),
    );
  }

  Widget _buildKeyPointsSection() {
    return _buildExpandableListSection(
      title: 'Key Points',
      icon: Icons.key,
      items: widget.lesson.keyPoints,
      sectionKey: 'keyPoints',
      color: Colors.orange.withOpacity(0.8),
    );
  }

  Widget _buildPreventionSection() {
    return _buildExpandableListSection(
      title: 'Prevention Steps',
      icon: Icons.shield,
      items: widget.lesson.preventionSteps,
      sectionKey: 'prevention',
      color: Colors.blue.withOpacity(0.8),
    );
  }

  Widget _buildDetectionSection() {
    return _buildExpandableListSection(
      title: 'Detection Methods',
      icon: Icons.search,
      items: widget.lesson.detectionMethods,
      sectionKey: 'detection',
      color: Colors.purple.withOpacity(0.8),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required String content,
    required String sectionKey,
    required Color color,
  }) {
    final isExpanded = expandedSection == sectionKey;
    
    return Card(
      color: const Color(0xFF2D3E50),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(sectionKey),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Colors.white24, thickness: 1),
                        const SizedBox(height: 12.0),
                        Text(
                          content,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableListSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required String sectionKey,
    required Color color,
  }) {
    final isExpanded = expandedSection == sectionKey;
    
    return Card(
      color: const Color(0xFF2D3E50),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(sectionKey),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Colors.white24, thickness: 1),
                        const SizedBox(height: 12.0),
                        ...items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4.0),
                                  width: 6.0,
                                  height: 6.0,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.0,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Card(
      color: const Color(0xFF2D3E50),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.cyan, size: 20.0),
                SizedBox(width: 8.0),
                Text(
                  'Lesson Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12.0),
            // _buildMetadataRow('Source Indicator', widget.lesson.sourceIndicator),
            _buildMetadataRow('Source Threat ID', widget.lesson.threatId.toString()),
            _buildMetadataRow('Created', _formatDate(widget.lesson.createdAt)),
            _buildMetadataRow('Last Updated', _formatDate(widget.lesson.updatedAt)),
            if (widget.lesson.tags.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              const Text(
                'Tags:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: widget.lesson.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 12.0,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
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
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}