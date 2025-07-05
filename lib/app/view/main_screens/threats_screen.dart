// import 'package:flutter/material.dart';

// class ThreatScreen extends StatefulWidget {
//   const ThreatScreen({super.key});

//   @override
//   State<ThreatScreen> createState() => _ThreatScreenState();
// }

// class _ThreatScreenState extends State<ThreatScreen> {
//   Future<List<Map<String, dynamic>>> fetchThreats() async {
//     // Replace this with your actual API call
//     await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//     return [
//       {
//         'title': 'Ransomware Attack',
//         'description': 'A ransomware attack has been detected, encrypting critical files and demanding a ransom for decryption.',
//         'date': '2024-01-15',
//         'severity': 'high',
//       },
//       {
//         'title': 'Phishing Campaign',
//         'description': 'A sophisticated phishing campaign targeting employees with fraudulent emails to steal login credentials.',
//         'date': '2024-01-12',
//         'severity': 'medium',
//       },
//       {
//         'title': 'Data Breach',
//         'description': 'A significant data breach has exposed sensitive customer information, including personal and financial data.',
//         'date': '2024-01-10',
//         'severity': 'high',
//       },
//       {
//         'title': 'Malware Infection',
//         'description': 'A widespread malware infection affecting multiple systems, causing performance issues and potential data loss.',
//         'date': '2024-01-08',
//         'severity': 'medium',
//       },
//       {
//         'title': 'Cyber Espionage',
//         'description': 'A cyber espionage operation targeting intellectual property and confidential business information.',
//         'date': '2024-01-05',
//         'severity': 'low',
//       },
//       {
//         'title': 'DDoS Attack',
//         'description': 'A distributed denial-of-service (DDoS) attack disrupting network services and causing website downtime.',
//         'date': '2024-01-02',
//         'severity': 'high',
//       },
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A252F),
//       appBar: AppBar(
//         title: const Text(
//           'Threat Intelligence',
//           style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A252F),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               setState(() {}); // Refresh data
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchThreats(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: Colors.white));
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text('Error loading threats', style: TextStyle(color: Colors.white)));
//           }
//           final threats = snapshot.data ?? [];
//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: threats.length,
//             itemBuilder: (context, index) {
//               final threat = threats[index];
//               Color severityColor = threat['severity'] == 'high'
//                   ? Colors.red
//                   : threat['severity'] == 'medium'
//                       ? Colors.orange
//                       : Colors.orange[200] ?? Colors.orange;
//               return Card(
//                 color: const Color(0xFF1A252F),
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 elevation: 2.0,
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(16.0),
//                   title: Text(
//                     threat['title']!,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           threat['description']!,
//                           style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             threat['date']!,
//                             style: const TextStyle(color: Colors.white, fontSize: 12.0),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               // TODO: Navigate to more details
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2D3E50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                             ),
//                             child: const Text(
//                               'More details',
//                               style: TextStyle(color: Colors.white, fontSize: 12.0),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   trailing: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                     decoration: BoxDecoration(
//                       color: severityColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       threat['severity']!,
//                       style: const TextStyle(color: Colors.white, fontSize: 12.0),
//                     ),
//                   ),
//                   isThreeLine: true,
//                   enabled: true,
//                   onTap: () {
//                     // TODO: Handle tap if needed
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project/app/controller/services/threat_api_service.dart';
import 'package:project/app/model/threat_model.dart';
import 'package:project/app/view/details_screens/threat_details_screen.dart';


class ThreatScreen extends StatefulWidget {
  const ThreatScreen({super.key});

  @override
  State<ThreatScreen> createState() => _ThreatScreenState();
}

class _ThreatScreenState extends State<ThreatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A252F),
      appBar: AppBar(
        title: const Text(
          'Threat Intelligence',
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A252F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<ThreatModel>(
        future: ThreatService().fetchThreats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError) {
            // Display error
            return Center(
                child: Text(
              'Error loading threats: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ));
          }
          
          var threats = snapshot.data!.results!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: threats.length,
            itemBuilder: (context, index) {
              var threat = threats[index];
              log('threat gotten ${threat.threat}');
              Color severityColor = threat.risk == 'high'
                  ? Colors.red
                  : threat.risk == 'medium'
                      ? Colors.orange
                      : Colors.orange[200] ?? Colors.orange;
              return Card(
                color: const Color(0xFF1A252F),
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    threat.threat.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          threat.description.toString().isNotEmpty ? threat.description.toString() : 'No description available.',
                          style: const TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            threat.stampUpdated!.split(' ')[0], // Use updated date as primary date
                            style: const TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ThreatDetailScreen(threat: threat),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D3E50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'More details',
                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: severityColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      threat.risk.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                  isThreeLine: true,
                  enabled: true,
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ThreatDetailScreen(threat: threat),
                    //   ),
                    // );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}