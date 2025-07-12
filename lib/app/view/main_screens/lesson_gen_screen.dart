import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/app/controller/services/firestore_service.dart';
import 'package:project/app/controller/services/gemini_api_service.dart';
import 'package:project/app/model/threat_model.dart';
import 'package:project/app/model/lesson_model.dart';

class LessonGenerationScreen extends StatefulWidget {
  final ThreatModel threat;
  
  const LessonGenerationScreen({
    super.key,
    required this.threat,
  });

  @override
  State<LessonGenerationScreen> createState() => _LessonGenerationScreenState();
}

class _LessonGenerationScreenState extends State<LessonGenerationScreen> {
  final GeminiService _geminiService = GeminiService();
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isGenerating = false;
  bool _isSaving = false;
  bool _isCheckingExisting = false;
  bool _isAnalyzingNews = false;
  LessonModel? _generatedLesson;
  LessonModel? _existingLesson;
  String? _error;
  bool _isUpdatingExisting = false;
  
  // Enhanced analytics data
  Map<String, dynamic> _threatAnalytics = {};
  int _newsArticlesProcessed = 0;
  int _newsArticlesAccessible = 0;

  @override
  void initState() {
    super.initState();
    _checkExistingLesson();
  }

  Future<void> _checkExistingLesson() async {
    if (!_firebaseService.isAuthenticated) {
      setState(() {
        _error = 'User not authenticated';
      });
      return;
    }

    setState(() {
      _isCheckingExisting = true;
      _error = null;
    });

    try {
      final existing = await _firebaseService.getLessonByThreatId(widget.threat.id ?? '');
      if (existing != null) {
        setState(() {
          _existingLesson = existing;
          _isUpdatingExisting = true;
        });
      }
      
      // Analyze threat data before generating lesson
      await _analyzeThreatData();
      
      // Always generate a new lesson (either for creation or update)
      await _generateLesson();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isCheckingExisting = false;
      });
    }
  }

  Future<void> _analyzeThreatData() async {
    setState(() {
      _isAnalyzingNews = true;
    });

    try {
      // Analyze threat data for enhanced context
      _threatAnalytics = {
        'hasNews': widget.threat.news != null && widget.threat.news!.isNotEmpty,
        'hasCategory': widget.threat.category != null && widget.threat.category!.isNotEmpty,
        'hasOtherNames': widget.threat.othernames != null && widget.threat.othernames!.isNotEmpty,
        'hasRiskLevel': widget.threat.riskLevel != null || widget.threat.risk != null,
        'hasDescription': widget.threat.description != null && widget.threat.description!.isNotEmpty,
        'hasWikiSummary': widget.threat.wikisummary != null && widget.threat.wikisummary!.isNotEmpty,
        'totalNewsArticles': widget.threat.news?.length ?? 0,
        'riskLevel': widget.threat.riskLevel ?? widget.threat.risk ?? 'unknown',
        'category': widget.threat.category ?? 'uncategorized',
        'otherNamesCount': widget.threat.othernames?.length ?? 0,
      };

      // Analyze news accessibility
      if (widget.threat.news != null && widget.threat.news!.isNotEmpty) {
        _newsArticlesProcessed = widget.threat.news!.length;
        
        // Test accessibility of news links (sample a few)
        final testLinks = widget.threat.news!.take(3).map((n) => n.link).toList();
        int accessibleCount = 0;
        
        for (final link in testLinks) {
          try {
            // Quick HEAD request to check accessibility
            final response = await http.head(Uri.parse(link)).timeout(const Duration(seconds: 5));
            if (response.statusCode == 200) {
              accessibleCount++;
            }
          } catch (e) {
            // Link not accessible
          }
        }
        
        _newsArticlesAccessible = accessibleCount;
        _threatAnalytics['newsAccessibilityRate'] = accessibleCount / testLinks.length;
      }

      setState(() {
        _isAnalyzingNews = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzingNews = false;
      });
      // Don't fail the entire process if analytics fail
    }
  }

  Future<void> _generateLesson() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final lesson = await _geminiService.generateLessonFromThreat(widget.threat);
      
      // If updating existing lesson, preserve the original ID and creation date
      if (_existingLesson != null) {
        final updatedLesson = lesson.copyWith(
          id: _existingLesson!.id,
          createdAt: _existingLesson!.createdAt,
        );
        setState(() {
          _generatedLesson = updatedLesson;
          _isGenerating = false;
          _isCheckingExisting = false;
        });
      } else {
        setState(() {
          _generatedLesson = lesson;
          _isGenerating = false;
          _isCheckingExisting = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isGenerating = false;
        _isCheckingExisting = false;
      });
    }
  }

  Future<void> _saveLesson() async {
    if (_generatedLesson == null) return;

    if (!_firebaseService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to save lessons'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _firebaseService.saveLesson(_generatedLesson!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isUpdatingExisting 
                ? 'Lesson updated successfully!' 
                : 'Lesson saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${_isUpdatingExisting ? 'update' : 'save'} lesson: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          _isUpdatingExisting ? 'Update Lesson' : 'Generate Lesson',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_generatedLesson != null && !_isSaving && !_isCheckingExisting)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _generateLesson,
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _generatedLesson != null
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildBody() {
    if (_isCheckingExisting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460)),
            ),
            SizedBox(height: 20),
            Text(
              'Generating lessons...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_isAnalyzingNews) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460)),
            ),
            const SizedBox(height: 20),
            Text(
              'Analyzing threat intelligence data...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Processing ${_newsArticlesProcessed} news articles',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460)),
            ),
            const SizedBox(height: 20),
            Text(
              _isUpdatingExisting 
                  ? 'Regenerating lesson content...' 
                  : 'Generating comprehensive lesson...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Including news analysis and threat intelligence',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 20),
            Text(
              'Error ${_isUpdatingExisting ? 'updating' : 'generating'} lesson',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkExistingLesson,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3460),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_generatedLesson == null) {
      return const Center(
        child: Text(
          'No lesson generated',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced analytics banner
          _buildAnalyticsBanner(),
          const SizedBox(height: 10),
          
          // Update notification banner
          if (_isUpdatingExisting)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'You already have a lesson for this threat. The content has been regenerated with the latest threat intelligence and news analysis.',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          
          // Enhanced Threat Info Card
          _buildEnhancedThreatInfoCard(),
          const SizedBox(height: 20),
          
          // Lesson Preview Card
          _buildLessonPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBanner() {
    if (_threatAnalytics.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.green),
              const SizedBox(width: 10),
              const Text(
                'Threat Intelligence Analysis',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (_threatAnalytics['hasNews'] == true)
                _buildAnalyticsChip('${_threatAnalytics['totalNewsArticles']} News Articles', Colors.blue),
              if (_threatAnalytics['hasCategory'] == true)
                _buildAnalyticsChip('Category: ${_threatAnalytics['category']}', Colors.purple),
              if (_threatAnalytics['hasOtherNames'] == true)
                _buildAnalyticsChip('${_threatAnalytics['otherNamesCount']} Aliases', Colors.orange),
              if (_threatAnalytics['hasRiskLevel'] == true)
                _buildAnalyticsChip(
                  'Risk: ${_threatAnalytics['riskLevel']}',
                  _threatAnalytics['riskLevel'] == 'high' ? Colors.red : 
                  _threatAnalytics['riskLevel'] == 'medium' ? Colors.orange : Colors.green,
                ),
              if (_newsArticlesAccessible > 0)
                _buildAnalyticsChip('${_newsArticlesAccessible} Accessible Links', Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEnhancedThreatInfoCard() {
    return Card(
      color: const Color(0xFF16213E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhanced Threat Intelligence',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Indicator', widget.threat.indicator ?? 'N/A'),
            _buildInfoRow('Type', widget.threat.type ?? 'N/A'),
            _buildInfoRow('Category', widget.threat.category ?? 'N/A'),
            _buildInfoRow('Risk Level', widget.threat.riskLevel ?? widget.threat.risk ?? 'N/A'),
            if (widget.threat.othernames != null && widget.threat.othernames!.isNotEmpty)
              _buildInfoRow('Alternative Names', widget.threat.othernames!.join(', ')),
            if (widget.threat.description != null)
              _buildInfoRow('Description', widget.threat.description!),
            if (widget.threat.news != null && widget.threat.news!.isNotEmpty)
              _buildInfoRow('News Coverage', '${widget.threat.news!.length} articles available'),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonPreviewCard() {
    final lesson = _generatedLesson!;
    
    return Card(
      color: const Color(0xFF16213E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_isUpdatingExisting ? 'Updated' : 'Generated'} Lesson Preview',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_isUpdatingExisting)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Title
            Text(
              lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Enhanced metadata
            Row(
              children: [
                _buildChip('Difficulty: ${lesson.difficulty}', Colors.blue),
                const SizedBox(width: 10),
                _buildChip('Risk: ${lesson.riskLevel}', 
                    lesson.riskLevel == 'high' ? Colors.red : 
                    lesson.riskLevel == 'medium' ? Colors.orange : Colors.green),
                const SizedBox(width: 10),
                _buildChip('Enhanced Intel', Colors.purple),
              ],
            ),
            const SizedBox(height: 15),
            
            // Summary
            const Text(
              'Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              lesson.summary,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 15),
            
            // Content Preview
            const Text(
              'Content Preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              lesson.content.length > 300 
                  ? '${lesson.content.substring(0, 300)}...'
                  : lesson.content,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 15),
            
            // Key Points
            if (lesson.keyPoints.isNotEmpty) ...[
              const Text(
                'Key Points',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ...lesson.keyPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 15),
            ],
            
            // Prevention Steps
            if (lesson.preventionSteps.isNotEmpty) ...[
              const Text(
                'Prevention Steps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ...lesson.preventionSteps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 15),
            ],
            
            // Detection Methods
            if (lesson.detectionMethods.isNotEmpty) ...[
              const Text(
                'Detection Methods',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ...lesson.detectionMethods.map((method) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Text(
                        method,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 15),
            ],
            
            // Tags
            if (lesson.tags.isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: lesson.tags.map((tag) => 
                  _buildChip(tag, Colors.grey)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              
              onPressed: _isSaving ? null : () => _saveLesson(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                backgroundColor: const Color(0xFF0F3460),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _isUpdatingExisting ? 'Update' : 'Save',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}