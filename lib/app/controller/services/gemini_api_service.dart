import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:project/app/model/threat_model.dart';
import 'package:project/app/model/lesson_model.dart';

class GeminiService {
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  static const String apiKey =
      'AIzaSyA1GFp6LlDHOAdVVe8iSZjR0xGavUq7yRg'; // Replace with your actual API key

  // Enhanced prompt template with more threat intelligence context
  static const String lessonPrompt = '''
You are a cybersecurity education expert. Based on the following comprehensive threat intelligence data, create a detailed cybersecurity lesson. The lesson should be educational, practical, and suitable for cybersecurity professionals and enthusiasts.

COMPREHENSIVE THREAT INTELLIGENCE DATA:
{threat_data}

RECENT NEWS ANALYSIS:
{news_analysis}

Please generate a structured lesson with the following components and return it as a JSON object with these exact fields:

{
  "title": "A clear, engaging title for the lesson that reflects the current threat landscape",
  "summary": "A brief 2-3 sentence summary of what the lesson covers, incorporating recent developments",
  "content": "The main lesson content (detailed explanation, examples, real-world scenarios). Include references to recent news and developments. This should be comprehensive and educational.",
  "keyPoints": ["Key point 1", "Key point 2", "Key point 3", "Key point 4", "Key point 5"],
  "preventionSteps": ["Prevention step 1", "Prevention step 2", "Prevention step 3", "Prevention step 4", "Prevention step 5"],
  "detectionMethods": ["Detection method 1", "Detection method 2", "Detection method 3", "Detection method 4"],
  "difficulty": "beginner|intermediate|advanced",
  "tags": ["tag1", "tag2", "tag3", "tag4", "tag5"],
  "recentDevelopments": ["Recent development 1", "Recent development 2", "Recent development 3"],
  "riskAssessment": "A comprehensive risk assessment based on the threat intelligence and recent news"
}

Guidelines:
1. Make the lesson practical and actionable, incorporating recent threat developments
2. Include real-world examples and scenarios from recent news when available
3. Explain technical concepts in an accessible way
4. Provide specific, actionable prevention steps based on current threat landscape
5. Include detection methods that can be implemented against current variants
6. Use appropriate difficulty level based on the threat complexity and recent developments
7. Add relevant tags for categorization, including threat categories and affected systems
8. Reference recent news and developments to show current relevance
9. Ensure the content is educational and provides context for why this threat matters now
10. Include risk assessment that considers both historical and recent threat activity
11. If alternative names exist for the threat, explain the relationship between them
12. Consider the broader threat category when providing prevention and detection guidance

The lesson should be comprehensive enough to educate someone about this specific threat type, its current state, and how to defend against it based on the latest intelligence.
''';

  Future<LessonModel> generateLessonFromThreat(ThreatModel threat) async {
    try {
      // Prepare the enhanced threat data for the prompt
      final threatData = await _formatEnhancedThreatData(threat);
      final newsAnalysis = await _analyzeRecentNews(threat);

      // Replace placeholders in prompt
      final prompt = lessonPrompt
          .replaceAll('{threat_data}', threatData)
          .replaceAll('{news_analysis}', newsAnalysis);

      // Prepare the request body with enhanced generation config
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 8192,
          "stopSequences": [],
        },
      };

      log('Sending enhanced request to Gemini API...');

      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      log('Gemini API Response Status: ${response.statusCode}');
      log('Gemini API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Extract the generated text
        final generatedText =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        // Parse the JSON response from the AI
        final lessonData = _parseGeminiResponse(generatedText);

        // Create the enhanced lesson model
        final lesson = LessonModel(
          id: '', // Will be set when saving to Firebase
          title: lessonData['title'] ?? 'Enhanced Cybersecurity Lesson',
          content: lessonData['content'] ?? '',
          summary: lessonData['summary'] ?? '',
          threatType: threat.type ?? 'Unknown',
          riskLevel: threat.riskLevel ?? threat.risk ?? 'low',
          threatId: threat.threat ?? threat.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          keyPoints: List<String>.from(lessonData['keyPoints'] ?? []),
          preventionSteps: List<String>.from(
            lessonData['preventionSteps'] ?? [],
          ),
          detectionMethods: List<String>.from(
            lessonData['detectionMethods'] ?? [],
          ),
          difficulty: lessonData['difficulty'] ?? 'intermediate',
          tags: List<String>.from(lessonData['tags'] ?? []),
          // Add new fields if they exist in your LessonModel
          // recentDevelopments: List<String>.from(lessonData['recentDevelopments'] ?? []),
          // riskAssessment: lessonData['riskAssessment'] ?? '',
        );

        return lesson;
      } else {
        throw Exception(
          'Failed to generate lesson: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log('Error generating lesson: $e');
      throw Exception('Failed to generate lesson: $e');
    }
  }

  Future<String> _formatEnhancedThreatData(ThreatModel threat) async {
    final buffer = StringBuffer();

    buffer.writeln('=== CORE THREAT INFORMATION ===');
    buffer.writeln('Threat ID: ${threat.id}');
    buffer.writeln('Primary Indicator: ${threat.indicator ?? 'N/A'}');
    buffer.writeln('Threat Type: ${threat.type ?? 'N/A'}');
    buffer.writeln('Risk Level: ${threat.riskLevel ?? threat.risk ?? 'N/A'}');
    buffer.writeln('Main Threat Name: ${threat.threat ?? 'N/A'}');

    // Enhanced category information
    if (threat.category != null && threat.category!.isNotEmpty) {
      buffer.writeln('Threat Category: ${threat.category}');
      buffer.writeln(
        'Category Context: This threat belongs to the ${threat.category} category, which typically involves specific attack vectors and defense strategies.',
      );
    }

    // Alternative names and variants
    if (threat.othernames != null && threat.othernames!.isNotEmpty) {
      buffer.writeln('\n=== ALTERNATIVE NAMES & VARIANTS ===');
      buffer.writeln('Known Aliases: ${threat.othernames!.join(', ')}');
      buffer.writeln(
        'Naming Context: These alternative names may represent different variants, stages, or naming conventions used by different security vendors and researchers.',
      );
    }

    // Detailed descriptions
    buffer.writeln('\n=== THREAT DESCRIPTION ===');
    if (threat.description != null && threat.description!.isNotEmpty) {
      buffer.writeln('Technical Description: ${threat.description}');
    }

    if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty) {
      buffer.writeln('Summary: ${threat.wikisummary}');
    }

    // Timeline and intelligence tracking
    buffer.writeln('\n=== THREAT INTELLIGENCE TIMELINE ===');
    buffer.writeln('First Discovered: ${threat.stampAdded ?? 'N/A'}');
    buffer.writeln('Last Observed: ${threat.stampSeen ?? 'N/A'}');
    buffer.writeln('Intelligence Updated: ${threat.stampUpdated ?? 'N/A'}');

    // Risk assessment context
    buffer.writeln('\n=== RISK ASSESSMENT CONTEXT ===');
    final riskLevel = threat.riskLevel ?? threat.risk ?? 'unknown';
    buffer.writeln('Current Risk Level: ${riskLevel.toUpperCase()}');

    switch (riskLevel.toLowerCase()) {
      case 'high':
        buffer.writeln(
          'Risk Context: HIGH PRIORITY - This threat poses significant risk and requires immediate attention and comprehensive defensive measures.',
        );
        break;
      case 'medium':
        buffer.writeln(
          'Risk Context: MODERATE PRIORITY - This threat requires monitoring and standard defensive measures with regular assessment.',
        );
        break;
      case 'low':
        buffer.writeln(
          'Risk Context: LOW PRIORITY - This threat should be monitored but may not require immediate action unless circumstances change.',
        );
        break;
      default:
        buffer.writeln(
          'Risk Context: Risk level assessment needed based on current threat landscape and organizational exposure.',
        );
    }

    return buffer.toString();
  }

  Future<String> _analyzeRecentNews(ThreatModel threat) async {
    final buffer = StringBuffer();

    if (threat.news == null || threat.news!.isEmpty) {
      buffer.writeln('No recent news available for this threat.');
      return buffer.toString();
    }

    buffer.writeln('=== RECENT NEWS ANALYSIS ===');

    // Get the latest news sorted by timestamp
    final latestNews = threat.getLatestNews();

    if (latestNews.isEmpty) {
      buffer.writeln('No recent news available for this threat.');
      return buffer.toString();
    }

    buffer.writeln('Recent News Coverage (${latestNews.length} articles):');

    // Fetch and analyze news content
    for (int i = 0; i < latestNews.length; i++) {
      final news = latestNews[i];
      buffer.writeln('\n--- Article ${i + 1} ---');
      buffer.writeln('Title: ${news.title}');
      buffer.writeln('Source: ${news.channel}');
      buffer.writeln('Published: ${news.stamp}');
      buffer.writeln('Link: ${news.link}');

      // Attempt to fetch and summarize news content
      try {
        final newsContent = await _fetchNewsContent(news.link);
        if (newsContent.isNotEmpty) {
          buffer.writeln('Content Summary: ${newsContent}');
        }
      } catch (e) {
        log('Could not fetch news content for ${news.link}: $e');
        buffer.writeln(
          'Content: [Content not accessible - using title for context]',
        );
      }

      // Priority indicator
      if (news.primary == 1) {
        buffer.writeln('Priority: PRIMARY NEWS SOURCE');
      }
    }

    // News analysis summary
    buffer.writeln('\n=== NEWS ANALYSIS SUMMARY ===');
    buffer.writeln('Total Articles: ${latestNews.length}');
    buffer.writeln('Latest Article: ${latestNews.first.stamp}');
    buffer.writeln(
      'Primary Sources: ${latestNews.where((n) => n.primary == 1).length}',
    );
    buffer.writeln(
      'News Sources: ${latestNews.map((n) => n.channel).toSet().join(', ')}',
    );

    // Trend analysis
    if (latestNews.length > 1) {
      buffer.writeln('\nTrend Analysis:');
      buffer.writeln(
        '- This threat has ${latestNews.length} recent news articles, indicating ${latestNews.length > 3
            ? 'high'
            : latestNews.length > 1
            ? 'moderate'
            : 'low'} current activity',
      );
      buffer.writeln(
        '- Multiple news sources covering this threat suggests it is of significant concern to the security community',
      );
    }

    return buffer.toString();
  }

  Future<String> _fetchNewsContent(String url) async {
    try {
      // Basic timeout for news fetching
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': 'Mozilla/5.0 (compatible; ThreatIntelBot/1.0)',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Basic content extraction (you might want to use a proper HTML parser)
        final content = response.body;

        // Extract text content (basic approach - consider using html package for better parsing)
        final cleanContent = _extractTextFromHtml(content);

        // Return first 500 characters as summary
        return cleanContent.length > 500
            ? '${cleanContent.substring(0, 500)}...'
            : cleanContent;
      } else {
        return 'Content not accessible (HTTP ${response.statusCode})';
      }
    } catch (e) {
      log('Error fetching news content: $e');
      return 'Content not accessible';
    }
  }

  String _extractTextFromHtml(String html) {
    // Basic HTML tag removal (consider using html package for better parsing)
    String text = html
        .replaceAll(
          RegExp(
            r'<script[^>]*>.*?</script>',
            caseSensitive: false,
            dotAll: true,
          ),
          '',
        )
        .replaceAll(
          RegExp(
            r'<style[^>]*>.*?</style>',
            caseSensitive: false,
            dotAll: true,
          ),
          '',
        )
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return text;
  }

  Map<String, dynamic> _parseGeminiResponse(String generatedText) {
    try {
      // Try to find JSON in the response
      final jsonStart = generatedText.indexOf('{');
      final jsonEnd = generatedText.lastIndexOf('}');

      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        final jsonString = generatedText.substring(jsonStart, jsonEnd + 1);
        final parsedJson = json.decode(jsonString);

        // Ensure all required fields are present
        return {
          'title': parsedJson['title'] ?? 'Enhanced Cybersecurity Lesson',
          'summary':
              parsedJson['summary'] ??
              'A comprehensive cybersecurity lesson based on current threat intelligence.',
          'content': parsedJson['content'] ?? generatedText,
          'keyPoints':
              parsedJson['keyPoints'] ??
              ['Review the generated content for key insights'],
          'preventionSteps':
              parsedJson['preventionSteps'] ??
              ['Implement comprehensive security measures'],
          'detectionMethods':
              parsedJson['detectionMethods'] ??
              ['Monitor for indicators of compromise'],
          'difficulty': parsedJson['difficulty'] ?? 'intermediate',
          'tags':
              parsedJson['tags'] ?? ['cybersecurity', 'threat-intelligence'],
          'recentDevelopments': parsedJson['recentDevelopments'] ?? [],
          'riskAssessment':
              parsedJson['riskAssessment'] ??
              'Risk assessment based on available intelligence',
        };
      } else {
        // If no valid JSON found, create a comprehensive structure
        return {
          'title': 'Enhanced Cybersecurity Lesson',
          'summary':
              'A comprehensive cybersecurity lesson generated from current threat intelligence data.',
          'content': generatedText,
          'keyPoints': [
            'Review the generated content for key insights',
            'Understand the current threat landscape',
          ],
          'preventionSteps': [
            'Implement comprehensive security measures',
            'Monitor threat intelligence feeds',
          ],
          'detectionMethods': [
            'Monitor for indicators of compromise',
            'Implement behavioral analysis',
          ],
          'difficulty': 'intermediate',
          'tags': ['cybersecurity', 'threat-intelligence', 'current-threats'],
          'recentDevelopments': [
            'Content generated from latest threat intelligence',
          ],
          'riskAssessment':
              'Risk assessment based on available intelligence and recent developments',
        };
      }
    } catch (e) {
      log('Error parsing Gemini response: $e');
      // Return a comprehensive fallback structure
      return {
        'title': 'Enhanced Cybersecurity Lesson',
        'summary':
            'A comprehensive cybersecurity lesson generated from current threat intelligence data.',
        'content': generatedText,
        'keyPoints': [
          'Review the generated content for key insights',
          'Understand the current threat landscape',
        ],
        'preventionSteps': [
          'Implement comprehensive security measures',
          'Monitor threat intelligence feeds',
        ],
        'detectionMethods': [
          'Monitor for indicators of compromise',
          'Implement behavioral analysis',
        ],
        'difficulty': 'intermediate',
        'tags': ['cybersecurity', 'threat-intelligence', 'current-threats'],
        'recentDevelopments': [
          'Content generated from latest threat intelligence',
        ],
        'riskAssessment':
            'Risk assessment based on available intelligence and recent developments',
      };
    }
  }

  // Enhanced API connection test
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Test connection - respond with 'Connection successful'",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final generatedText =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        log('API Test Response: $generatedText');
        return true;
      }

      return false;
    } catch (e) {
      log('Gemini API test failed: $e');
      return false;
    }
  }
}
