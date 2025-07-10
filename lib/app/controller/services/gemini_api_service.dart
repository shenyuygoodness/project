import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:project/app/model/threat_model.dart';
import 'package:project/app/model/lesson_model.dart';

class GeminiService {
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  static const String apiKey = 'AIzaSyA1GFp6LlDHOAdVVe8iSZjR0xGavUq7yRg'; // Replace with your actual API key

  // Pre-written prompt template
  static const String lessonPrompt = '''
You are a cybersecurity education expert. Based on the following threat intelligence data, create a comprehensive cybersecurity lesson. The lesson should be educational, practical, and suitable for cybersecurity professionals and enthusiasts.

THREAT DATA:
{threat_data}

Please generate a structured lesson with the following components and return it as a JSON object with these exact fields:

{
  "title": "A clear, engaging title for the lesson",
  "summary": "A brief 2-3 sentence summary of what the lesson covers",
  "content": "The main lesson content (detailed explanation, examples, real-world scenarios). This should be comprehensive and educational.",
  "keyPoints": ["Key point 1", "Key point 2", "Key point 3"],
  "preventionSteps": ["Prevention step 1", "Prevention step 2", "Prevention step 3"],
  "detectionMethods": ["Detection method 1", "Detection method 2", "Detection method 3"],
  "difficulty": "beginner|intermediate|advanced",
  "tags": ["tag1", "tag2", "tag3"]
}

Guidelines:
1. Make the lesson practical and actionable
2. Include real-world examples and scenarios
3. Explain technical concepts in an accessible way
4. Provide specific, actionable prevention steps
5. Include detection methods that can be implemented
6. Use appropriate difficulty level based on the threat complexity
7. Add relevant tags for categorization
8. Ensure the content is educational and not just informational

The lesson should be comprehensive enough to educate someone about this specific threat type and how to defend against it.
''';

  Future<LessonModel> generateLessonFromThreat(ThreatModel threat) async {
    try {
      // Prepare the threat data for the prompt
      final threatData = _formatThreatData(threat);
      
      // Replace placeholder in prompt
      final prompt = lessonPrompt.replaceAll('{threat_data}', threatData);
      
      // Prepare the request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": prompt
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 8192,
        }
      };

      log('Sending request to Gemini API...');
      
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      log('Gemini API Response Status: ${response.statusCode}');
      log('Gemini API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Extract the generated text
        final generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];
        
        // Parse the JSON response from the AI
        final lessonData = _parseGeminiResponse(generatedText);
        
        // Create the lesson model
        final lesson = LessonModel(
          id: '', // Will be set when saving to Firebase
          title: lessonData['title'] ?? 'Cybersecurity Lesson',
          content: lessonData['content'] ?? '',
          summary: lessonData['summary'] ?? '',
          threatType: threat.type ?? 'Unknown',
          riskLevel: threat.riskLevel ?? 'low',
          sourceIndicator: threat.indicator ?? 'N/A',
          sourceThreatId: threat.threat != null ? int.tryParse(threat.threat!) ?? 0 : 0,
          news: threat.news ?? [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          keyPoints: List<String>.from(lessonData['keyPoints'] ?? []),
          preventionSteps: List<String>.from(lessonData['preventionSteps'] ?? []),
          detectionMethods: List<String>.from(lessonData['detectionMethods'] ?? []),
          difficulty: lessonData['difficulty'] ?? 'beginner',
          tags: List<String>.from(lessonData['tags'] ?? []),
        );

        return lesson;
      } else {
        throw Exception('Failed to generate lesson: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error generating lesson: $e');
      throw Exception('Failed to generate lesson: $e');
    }
  }

  String _formatThreatData(ThreatModel threat) {
    final buffer = StringBuffer();
    
    buffer.writeln('Threat Information:');
    buffer.writeln('- Indicator: ${threat.indicator ?? 'N/A'}');
    buffer.writeln('- Type: ${threat.type ?? 'N/A'}');
    buffer.writeln('- Risk Level: ${threat.riskLevel ?? 'N/A'}');
    buffer.writeln('- Description: ${threat.wikisummary ?? 'N/A'}');
    
    if (threat.category != null && threat.category!.isNotEmpty) {
      buffer.writeln('- Categories: ${threat.category}');
    }
    
    if (threat.news != null && threat.news!.isNotEmpty) {
      buffer.writeln('\nRecent News:');
      final latestNews = threat.getLatestNews();
      for (var news in latestNews.take(3)) {
        buffer.writeln('- ${news.title} (${news.channel})');
      }
    }
    
    buffer.writeln('\nTimestamps:');
    buffer.writeln('- First Seen: ${threat.stampAdded ?? 'N/A'}');
    buffer.writeln('- Last Seen: ${threat.stampSeen ?? 'N/A'}');
    buffer.writeln('- Last Updated: ${threat.stampUpdated ?? 'N/A'}');
    
    return buffer.toString();
  }

  Map<String, dynamic> _parseGeminiResponse(String generatedText) {
    try {
      // Try to find JSON in the response
      final jsonStart = generatedText.indexOf('{');
      final jsonEnd = generatedText.lastIndexOf('}');
      
      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        final jsonString = generatedText.substring(jsonStart, jsonEnd + 1);
        return json.decode(jsonString);
      } else {
        // If no valid JSON found, create a basic structure
        return {
          'title': 'Generated Cybersecurity Lesson',
          'summary': 'A cybersecurity lesson generated from threat intelligence data.',
          'content': generatedText,
          'keyPoints': ['Review the generated content for key insights'],
          'preventionSteps': ['Implement security best practices'],
          'detectionMethods': ['Monitor for indicators of compromise'],
          'difficulty': 'intermediate',
          'tags': ['cybersecurity', 'threat-intelligence']
        };
      }
    } catch (e) {
      log('Error parsing Gemini response: $e');
      // Return a fallback structure
      return {
        'title': 'Generated Cybersecurity Lesson',
        'summary': 'A cybersecurity lesson generated from threat intelligence data.',
        'content': generatedText,
        'keyPoints': ['Review the generated content for key insights'],
        'preventionSteps': ['Implement security best practices'],
        'detectionMethods': ['Monitor for indicators of compromise'],
        'difficulty': 'intermediate',
        'tags': ['cybersecurity', 'threat-intelligence']
      };
    }
  }

  // Test the API connection
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {"text": "Say hello"}
              ]
            }
          ]
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      log('Gemini API test failed: $e');
      return false;
    }
  }
}