import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/app/model/threat_model.dart';

// class ThreatService {
//   static const String baseUrl = 'https://pulsedive.com/api/info.php';
//   static const String apiKey =
//       'ed7c4a81552db612cd085eb20a9dbedec25a20f2a10d6a9d626bfe1e6c321c6a';

//   Future<ThreatModel> fetchThreats() async {
//     try {
//       Map<String, String> headers = {"Content-Type": "application/json"};
//       final response = await http.get(
//         Uri.parse('$baseUrl?tid=1&pretty=1&key=$apiKey'),
//         headers: headers,
//       );
//       log('$baseUrl?tid=1&pretty=1&key=$apiKey');
//       debugPrint(response.toString());
//       log("message: $response");
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         var data = json.decode(response.body);
//         print(data);

//         return ThreatModel.fromJson(data);
//       } else {
//         throw Exception('Failed to load threats: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('');
//     }
//   }




class ThreatService {
  static const String baseUrl = 'https://pulsedive.com/api/info.php';
  static const String apiKey = 'ed7c4a81552db612cd085eb20a9dbedec25a20f2a10d6a9d626bfe1e6c321c6a';

  Future<ThreatModel> fetchThreats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?tid=1&pretty=1&key=$apiKey'),
      );
      
      log('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ThreatModel.fromJson(data);
      } else {
        throw Exception('Failed to load threats: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error fetching threats: $e');
      throw Exception('Failed to load threats: $e');
    }
  }
}

















// threat_api_services.dart
// class ThreatService {
//   static const String baseUrl = 'https://pulsedive.com/api';
//   static const String apiKey = 'ed7c4a81552db612cd085eb20a9dbedec25a20f2a10d6a9d626bfe1e6c321c6a';

//   // Fetch list of basic threat info
//   Future<List<BasicThreat>> fetchThreatList() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/explore.php?q=threat&limit=10&pretty=1&key=$apiKey'),
        
//       );
//       log('Request URL: $baseUrl'); // Add this line
//         log('response ${response.body}');
      
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['results'] != null) {
//           return (data['results'] as List)
//               .map((json) => BasicThreat.fromJson(json))
//               .toList();
//         }
//         log('Parsed data: $data'); // Add this line
//         throw Exception('No results found');
//       } else {
//         throw Exception('Failed to load threats: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load threat list: $e');
//     }
//   }

  // Fetch detailed threat info
//   Future<DetailedThreat> fetchThreatDetails(int tid) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/info.php?tid=$tid&pretty=1&key=$apiKey'),
//       );
      
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         return DetailedThreat.fromJson(data);
//       } else {
//         throw Exception('Failed to load threat details: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load threat details: $e');
//     }
//   }
// }




  //   final response = await http.get(
  //     Uri.parse('$baseUrl?tid=1&pretty=1&key=$apiKey'),
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     final List<dynamic> results = data['results'] ?? [];
  //     return results.map((json) => Threat.fromJson(json)).toList();
  //     // final List<dynamic> data = json.decode(response.body);
  //     // return data.map((json) => Threat.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load threats: ${response.statusCode}');
  //   }
  // }
// }
