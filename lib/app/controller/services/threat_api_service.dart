import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/app/model/threat_model.dart';

class ThreatService {
  static const String baseUrl = 'https://pulsedive.com/api/info.php';
  static const String apiKey =
      'ed7c4a81552db612cd085eb20a9dbedec25a20f2a10d6a9d626bfe1e6c321c6a';

  Future<ThreatModel> fetchThreats() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.get(
        Uri.parse('$baseUrl?tid=1&pretty=1&key=$apiKey'),
        headers: headers,
      );
      log('$baseUrl?tid=1&pretty=1&key=$apiKey');
      debugPrint(response.toString());
      log("message: $response");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        print(data);

        return ThreatModel.fromJson(data);
      } else {
        throw Exception('Failed to load threats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('');
    }
  }
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
}
