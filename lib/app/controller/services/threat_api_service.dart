import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/app/model/threat_model.dart';

class ThreatService {
  static const String baseUrl = 'https://pulsedive.com/api/info.php';
  static const String exploreUrl = 'https://pulsedive.com/api/explore.php';
  static const String apiKey = 'b4b7fde5b582c947c58e7ae89a2f3bd7f848ecf770cb705b0ddd1af6c1fe16ad';

  // Fetch threat by ID
  Future<ThreatModel> fetchThreatById(int tid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?tid=$tid&pretty=1&key=$apiKey'),
      );
      
      log('API Response for TID $tid: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ThreatModel.fromJson(data);
      } else {
        throw Exception('Failed to load threat: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error fetching threat by ID $tid: $e');
      throw Exception('Failed to load threat: $e');
    }
  }

  // Fetch threats - default to TID 1
  Future<ThreatModel> fetchThreats() async {
    return fetchThreatById(1);
  }

  // Search threats by query (can be threat ID or name)
  Future<List<SearchResult>> searchThreats(String query) async {
    try {
      // First try to parse as an ID
      int? threatId = int.tryParse(query);
      if (threatId != null) {
        // If it's a valid ID, fetch that specific threat
        try {
          final threat = await fetchThreatById(threatId);
          return [
            SearchResult(
              id: threatId,
              indicator: threat.indicator ?? 'Unknown',
              type: threat.type ?? 'Unknown',
              riskLevel: threat.riskLevel ?? 'low',
            )
          ];
        } catch (e) {
          // If fetching by ID fails, continue with text search
        }
      }

      // Search by text query
      final response = await http.get(
        Uri.parse('$exploreUrl?q=$query&limit=20&pretty=1&key=$apiKey'),
      );
      
      log('Search API Response for query "$query": ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        return results.map((json) => SearchResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search threats: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error searching threats: $e');
      throw Exception('Failed to search threats: $e');
    }
  }
}

// Model for search results
class SearchResult {
  final int id;
  final String indicator;
  final String type;
  final String riskLevel;

  SearchResult({
    required this.id,
    required this.indicator,
    required this.type,
    required this.riskLevel,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['tid'] ?? json['id'] ?? 0,
      indicator: json['indicator'] ?? json['name'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      riskLevel: json['risk'] ?? json['riskLevel'] ?? 'low',
    );
  }
}