import 'package:flutter/material.dart';
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
  LessonModel? _generatedLesson;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateLesson();
  }

  Future<void> _generateLesson() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final lesson = await _geminiService.generateLessonFromThreat(widget.threat);
      setState(() {
        _generatedLesson = lesson;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isGenerating = false;
      });
    }
  }

  Future<void> _saveLesson() async {
    if (_generatedLesson == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _firebaseService.saveLesson(_generatedLesson!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save lesson: $e'),
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
        title: const Text(
          'Generated Lesson',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_generatedLesson != null && !_isSaving)
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
    if (_isGenerating) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460)),
            ),
            SizedBox(height: 20),
            Text(
              'Generating lesson...',
              style: TextStyle(color: Colors.white, fontSize: 16),
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
              'Error generating lesson',
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
              onPressed: _generateLesson,
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
          // Threat Info Card
          _buildThreatInfoCard(),
          const SizedBox(height: 20),
          
          // Lesson Preview Card
          _buildLessonPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildThreatInfoCard() {
    return Card(
      color: const Color(0xFF16213E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Source Threat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Indicator', widget.threat.indicator ?? 'N/A'),
            _buildInfoRow('Type', widget.threat.type ?? 'N/A'),
            _buildInfoRow('Risk Level', widget.threat.riskLevel ?? 'N/A'),
            if (widget.threat.description != null)
              _buildInfoRow('Description', widget.threat.description!),
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
            const Text(
              'Generated Lesson Preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
            
            // Difficulty and Risk Level
            Row(
              children: [
                _buildChip('Difficulty: ${lesson.difficulty}', Colors.blue),
                const SizedBox(width: 10),
                _buildChip('Risk: ${lesson.riskLevel}', 
                    lesson.riskLevel == 'high' ? Colors.red : 
                    lesson.riskLevel == 'medium' ? Colors.orange : Colors.green),
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
            width: 80,
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
              onPressed: _isSaving ? null : _saveLesson,
              style: ElevatedButton.styleFrom(
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
                  : const Text(
                      'Save Lesson',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}