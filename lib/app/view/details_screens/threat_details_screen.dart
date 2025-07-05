// import 'package:flutter/material.dart';
// import 'package:project/app/model/threat_model.dart';


// class ThreatDetailScreen extends StatelessWidget {
//   final Threat threat;

//   const ThreatDetailScreen({super.key, required this.threat});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A252F),
//       appBar: AppBar(
//         title: Text(
//           threat.threat,
//           style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A252F),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Card(
//               color: const Color(0xFF1A252F),
//               elevation: 2.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Category: ${threat.category}',
//                       style: const TextStyle(color: Colors.white, fontSize: 16.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Risk: ${threat.risk}',
//                       style: const TextStyle(color: Colors.white, fontSize: 16.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Description: ${threat.description.isNotEmpty ? threat.description : 'No description available.'}',
//                       style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Added: ${threat.stampAdded}',
//                       style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Last Updated: ${threat.stampUpdated}',
//                       style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty)
//                       Text(
//                         'Wiki Summary: ${threat.wikisummary}',
//                         style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                       ),
//                     if (threat.wikireference != null && threat.wikireference!.isNotEmpty)
//                       GestureDetector(
//                         onTap: () => _launchURL(threat.wikireference!),
//                         child: Text(
//                           'Wiki Reference: ${threat.wikireference}',
//                           style: const TextStyle(
//                             color: Colors.blue,
//                             fontSize: 14.0,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 16.0),
//                     const Text(
//                       'News',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     ...threat.news.map((newsItem) => Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 newsItem['title'],
//                                 style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                               ),
//                               Text(
//                                 'Source: ${newsItem['channel']}, Date: ${newsItem['stamp']}',
//                                 style: const TextStyle(color: Colors.grey, fontSize: 12.0),
//                               ),
//                             ],
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _launchURL(String url) async {
//     // TODO: Implement URL launching (e.g., using url_launcher package)
//     // if (await canLaunch(url)) {
//     //   await launch(url);
//     // } else {
//     //   throw 'Could not launch $url';
//     // }
//   }
// }