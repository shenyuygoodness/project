// import 'package:flutter/material.dart';
// import 'package:project/app/controller/services/threat_api_service.dart';
// import 'package:project/app/model/threat_model.dart' hide SearchResult;
// import 'package:url_launcher/url_launcher.dart';

// class ThreatScreen extends StatefulWidget {
//   const ThreatScreen({super.key});

//   @override
//   State<ThreatScreen> createState() => _ThreatScreenState();
// }

// class _ThreatScreenState extends State<ThreatScreen> with TickerProviderStateMixin {
//   late Future<ThreatModel> futureThreat;
//   bool isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<double> _expandAnimation;
  
//   // Navigation and search variables
//   int currentThreatId = 1;
//   final TextEditingController _searchController = TextEditingController();
//   List<SearchResult> searchResults = [];
//   bool isSearching = false;
//   bool showSearchResults = false;

//   @override
//   void initState() {
//     super.initState();
//     futureThreat = ThreatService().fetchThreatById(currentThreatId);
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _expandAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void refreshData() {
//     setState(() {
//       futureThreat = ThreatService().fetchThreatById(currentThreatId);
//     });
//   }

//   void toggleExpanded() {
//     setState(() {
//       isExpanded = !isExpanded;
//       if (isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   void navigateToNextThreat() {
//     setState(() {
//       currentThreatId++;
//       futureThreat = ThreatService().fetchThreatById(currentThreatId);
//       isExpanded = false;
//       _animationController.reverse();
//     });
//   }

//   void navigateToPreviousThreat() {
//     if (currentThreatId > 1) {
//       setState(() {
//         currentThreatId--;
//         futureThreat = ThreatService().fetchThreatById(currentThreatId);
//         isExpanded = false;
//         _animationController.reverse();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Already at the first threat')),
//       );
//     }
//   }

//   void searchThreats(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         showSearchResults = false;
//         searchResults = [];
//       });
//       return;
//     }

//     setState(() {
//       isSearching = true;
//       showSearchResults = true;
//     });

//     try {
//       final results = await ThreatService().searchThreats(query);
//       setState(() {
//         searchResults = results;
//         isSearching = false;
//       });
//     } catch (e) {
//       setState(() {
//         isSearching = false;
//         searchResults = [];
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Search failed: $e')),
//       );
//     }
//   }

//   void selectThreat(int threatId) {
//     setState(() {
//       currentThreatId = threatId;
//       futureThreat = ThreatService().fetchThreatById(currentThreatId);
//       showSearchResults = false;
//       _searchController.clear();
//       isExpanded = false;
//       _animationController.reverse();
//     });
//   }

// // Replace your existing _launchURL method with this improved version
// Future<void> _launchURL(String url) async {
//   try {
//     // Clean and validate the URL
//     String cleanUrl = url.trim();
    
//     // Add protocol if missing
//     if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
//       cleanUrl = 'https://$cleanUrl';
//     }
    
//     // Parse the URL
//     final Uri? uri = Uri.tryParse(cleanUrl);
    
//     if (uri == null) {
//       throw Exception('Invalid URL format');
//     }
    
//     // Debug: Print the URL being launched
//     print('Attempting to launch URL: $cleanUrl');
    
//     // Check if URL can be launched
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication,
//       );
//     } else {
//       throw Exception('No app available to handle this URL');
//     }
//   } catch (e) {
//     print('URL launch error: $e');
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Could not launch URL: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
// }

//   // Method to launch URL
//   // Future<void> _launchURL(String url) async {
//   //   final Uri? uri = Uri.tryParse(url);
//   //   if (uri != null && await canLaunchUrl(uri)) {
//   //     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //   } else {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Could not launch $url')),
//   //       );
//   //     }
//   //   }
//   // }

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
//             onPressed: refreshData,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: searchThreats,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Search by threat ID or name...',
//                 hintStyle: const TextStyle(color: Colors.white60),
//                 prefixIcon: const Icon(Icons.search, color: Colors.white60),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.white60),
//                         onPressed: () {
//                           _searchController.clear();
//                           setState(() {
//                             showSearchResults = false;
//                             searchResults = [];
//                           });
//                         },
//                       )
//                     : null,
//                 filled: true,
//                 fillColor: const Color(0xFF2D3E50),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2.0),
//                 ),
//               ),
//             ),
//           ),
          
//           // Search Results or Main Content
//           Expanded(
//             child: showSearchResults ? _buildSearchResults() : _buildMainContent(),
//           ),
          
//           // Navigation Buttons (only show when not searching)
//           if (!showSearchResults)
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: navigateToPreviousThreat,
//                       icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                       label: const Text('Previous', style: TextStyle(color: Colors.white)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2D3E50),
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2D3E50),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       'ID: $currentThreatId',
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: navigateToNextThreat,
//                       icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//                       label: const Text('Next', style: TextStyle(color: Colors.white)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2D3E50),
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Search Results',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           Expanded(
//             child: isSearching
//                 ? const Center(child: CircularProgressIndicator(color: Colors.white))
//                 : searchResults.isEmpty
//                     ? const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.search_off, color: Colors.white60, size: 48),
//                             SizedBox(height: 16),
//                             Text(
//                               'No results found',
//                               style: TextStyle(color: Colors.white60, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: searchResults.length,
//                         itemBuilder: (context, index) {
//                           final result = searchResults[index];
//                           return Card(
//                             color: const Color(0xFF2D3E50),
//                             margin: const EdgeInsets.only(bottom: 8.0),
//                             child: ListTile(
//                               leading: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   color: _getRiskColor(result.riskLevel),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                                 child: Text(
//                                   result.riskLevel.toUpperCase(),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(
//                                 result.indicator,
//                                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 'Type: ${result.type} • ID: ${result.id}',
//                                 style: const TextStyle(color: Colors.white70),
//                               ),
//                               trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white60),
//                               onTap: () => selectThreat(result.id),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return FutureBuilder<ThreatModel>(
//       future: futureThreat,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator(color: Colors.white));
//         }
        
//         if (snapshot.hasError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 48),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Error loading threats',
//                   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '${snapshot.error}',
//                   style: const TextStyle(color: Colors.white70),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         }
        
//         if (!snapshot.hasData) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 48),
//                 SizedBox(height: 16),
//                 Text(
//                   'No threat data available',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//           );
//         }

//         final threat = snapshot.data!;
        
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             child: Card(
//               color: const Color(0xFF2D3E50),
//               elevation: 8,
//               shadowColor: Colors.black.withOpacity(0.3),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   // Collapsed Header
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 threat.threat!.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                 color: _getRiskColor(threat.riskLevel ?? 'low'),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: Text(
//                                 threat.riskLevel?.toUpperCase() ?? 'LOW',
//                                 style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12.0),
//                         if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty)
//                           Text(
//                             _getTruncatedDescription(threat.wikisummary!, 100),
//                             style: const TextStyle(color: Colors.white70, fontSize: 14.0),
//                           ),
//                         const SizedBox(height: 16.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Chip(
//                               label: Text(
//                                 threat.type ?? 'Unknown Type',
//                                 style: const TextStyle(color: Colors.white, fontSize: 12),
//                               ),
//                               backgroundColor: Colors.blue.withOpacity(0.8),
//                             ),
//                             ElevatedButton.icon(
//                               onPressed: toggleExpanded,
//                               icon: AnimatedRotation(
//                                 turns: isExpanded ? 0.5 : 0.0,
//                                 duration: const Duration(milliseconds: 300),
//                                 child: const Icon(Icons.expand_more, color: Colors.white),
//                               ),
//                               label: Text(
//                                 isExpanded ? 'Show Less' : 'More Details',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF1A252F),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Expandable Content
//                   SizeTransition(
//                     sizeFactor: _expandAnimation,
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Divider(color: Colors.white24, thickness: 1),
//                           const SizedBox(height: 16.0),
                          
//                           // Full Description
//                           if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty)
//                             _buildInfoSection(
//                               'Full Description',
//                               threat.wikisummary!,
//                               Icons.description,
//                             ),
                          
//                           // Threats Section
//                           if (threat.threat != null && threat.threat!.isNotEmpty)
//                             _buildInfoSection(
//                               'Threats',
//                               threat.indicator ?? 'Unknown Indicator',
//                               Icons.warning,
//                               color: Colors.red.withOpacity(0.8),
//                             ),
                          
//                           // Categories Section
//                           if (threat.category != null && threat.category!.isNotEmpty)
//                             _buildInfoSection(
//                               'Categories',
//                               threat.category!.toString(),
//                               Icons.category,
//                               color: Colors.green.withOpacity(0.8),
//                             ),
                          
//                           // Latest News Section
//                           if (threat.news != null && threat.news!.isNotEmpty)
//                             _buildNewsSection(threat.getLatestNews()),
                          
//                           // Timestamps Section
//                           _buildTimestampsSection(threat),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoSection(String title, String content, IconData icon, {Color? color}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A252F).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(8.0),
//         border: const Border(left: BorderSide(color: Colors.blue, width: 4.0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color ?? Colors.blue, size: 20),
//               const SizedBox(width: 8.0),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             content,
//             style: const TextStyle(color: Colors.white70, fontSize: 14.0),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewsSection(List<NewsItem> latestNews) {
//     if (latestNews.isEmpty) return const SizedBox.shrink();
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A252F).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(8.0),
//         border: const Border(left: BorderSide(color: Colors.orange, width: 4.0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.article, color: Colors.orange, size: 20),
//               SizedBox(width: 8.0),
//               Text(
//                 'Latest News',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12.0),
//           ...latestNews.map((news) => _buildNewsItem(news)),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewsItem(NewsItem news) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2D3E50).withOpacity(0.7),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // Channel icon (placeholder as network images might not load in preview)
//               Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(4.0),
//                 ),
//                 child: const Icon(Icons.language, color: Colors.white70, size: 12),
//               ),
//               const SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   news.channel,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Text(
//                 _formatTimestamp(news.stamp),
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontSize: 11.0,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             news.title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           ElevatedButton.icon(
//             onPressed: () => _launchURL(news.link),
//             icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
//             label: const Text(
//               'Read More',
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange.withOpacity(0.8),
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6.0),
//               ),
//               minimumSize: const Size(0, 32),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  

//   Widget _buildTimestampsSection(ThreatModel threat) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A252F).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(8.0),
//         border: const Border(left: BorderSide(color: Colors.purple, width: 4.0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.access_time, color: Colors.purple, size: 20),
//               SizedBox(width: 8.0),
//               Text(
//                 'Timestamps',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8.0),
//           _buildTimestampRow('First Seen', threat.stampAdded),
//           _buildTimestampRow('Last Seen', threat.stampSeen),
//           _buildTimestampRow('Last Updated', threat.stampUpdated),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimestampRow(String label, String? timestamp) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: const TextStyle(color: Colors.white70, fontSize: 12.0),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               timestamp ?? 'Unknown',
//               style: const TextStyle(color: Colors.white, fontSize: 12.0),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getTruncatedDescription(String description, int maxLength) {
//     if (description.length <= maxLength) {
//       return description;
//     }
//     return '${description.substring(0, maxLength)}...';
//   }

//   String _formatTimestamp(String timestamp) {
//     try {
//       DateTime dateTime = DateTime.parse(timestamp);
//       Duration difference = DateTime.now().difference(dateTime);
      
//       if (difference.inDays > 0) {
//         return '${difference.inDays}d ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes}m ago';
//       } else {
//         return 'Just now';
//       }
//     } catch (e) {
//       return timestamp;
//     }
//   }

//   Color _getRiskColor(String riskLevel) {
//     switch (riskLevel.toLowerCase()) {
//       case 'high':
//         return Colors.red;
//       case 'medium':
//         return Colors.orange;
//       case 'low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/app/controller/services/threat_api_service.dart';
import 'package:project/app/model/threat_model.dart' hide SearchResult;
// import 'package:project/app/view/lesson_gen_screen.dart';
// import 'package:project/app/view/lessons_display_screen.dart';
import 'package:project/app/view/main_screens/lesson_gen_screen.dart';
import 'package:project/app/view/main_screens/lessons_display.dart';
import 'package:url_launcher/url_launcher.dart';

class ThreatScreen extends StatefulWidget {
  const ThreatScreen({super.key});

  @override
  State<ThreatScreen> createState() => _ThreatScreenState();
}

class _ThreatScreenState extends State<ThreatScreen> with TickerProviderStateMixin {
  late Future<ThreatModel> futureThreat;
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  
  // Navigation and search variables
  int currentThreatId = 1;
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> searchResults = [];
  bool isSearching = false;
  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    futureThreat = ThreatService().fetchThreatById(currentThreatId);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void refreshData() {
    setState(() {
      futureThreat = ThreatService().fetchThreatById(currentThreatId);
    });
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void navigateToNextThreat() {
    setState(() {
      currentThreatId++;
      futureThreat = ThreatService().fetchThreatById(currentThreatId);
      isExpanded = false;
      _animationController.reverse();
    });
  }

  void navigateToPreviousThreat() {
    if (currentThreatId > 1) {
      setState(() {
        currentThreatId--;
        futureThreat = ThreatService().fetchThreatById(currentThreatId);
        isExpanded = false;
        _animationController.reverse();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already at the first threat')),
      );
    }
  }

  void searchThreats(String query) async {
    if (query.isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
      showSearchResults = true;
    });

    try {
      final results = await ThreatService().searchThreats(query);
      setState(() {
        searchResults = results;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  void selectThreat(int threatId) {
    setState(() {
      currentThreatId = threatId;
      futureThreat = ThreatService().fetchThreatById(currentThreatId);
      showSearchResults = false;
      _searchController.clear();
      isExpanded = false;
      _animationController.reverse();
    });
  }

  // NEW: Navigate to lesson generation
  void generateLessonFromThreat(ThreatModel threat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonGenerationScreen(threat: threat),
      ),
    ).then((result) {
      // If lesson was saved successfully, show success message
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson generated and saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  // NEW: Navigate to lessons display
  void navigateToLessons() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LessonsListScreen(),
      ),
    );
  }

  // Replace your existing _launchURL method with this improved version
  Future<void> _launchURL(String url) async {
    try {
      // Clean and validate the URL
      String cleanUrl = url.trim();
      
      // Add protocol if missing
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        cleanUrl = 'https://$cleanUrl';
      }
      
      // Parse the URL
      final Uri? uri = Uri.tryParse(cleanUrl);
      
      if (uri == null) {
        throw Exception('Invalid URL format');
      }
      
      // Debug: Print the URL being launched
      print('Attempting to launch URL: $cleanUrl');
      
      // Check if URL can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('No app available to handle this URL');
      }
    } catch (e) {
      print('URL launch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch URL: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

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
          // NEW: View Lessons button
          IconButton(
            icon: const Icon(Icons.school, color: Colors.white),
            onPressed: navigateToLessons,
            tooltip: 'View Lessons',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: searchThreats,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by threat ID or name...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white60),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            showSearchResults = false;
                            searchResults = [];
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF2D3E50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ),
          
          // Search Results or Main Content
          Expanded(
            child: showSearchResults ? _buildSearchResults() : _buildMainContent(),
          ),
          
          // Navigation Buttons (only show when not searching)
          if (!showSearchResults)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: navigateToPreviousThreat,
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      label: const Text('Previous', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3E50),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3E50),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'ID: $currentThreatId',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: navigateToNextThreat,
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      label: const Text('Next', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3E50),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: isSearching
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : searchResults.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, color: Colors.white60, size: 48),
                            SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(color: Colors.white60, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return Card(
                            color: const Color(0xFF2D3E50),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: _getRiskColor(result.riskLevel),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  result.riskLevel.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                result.indicator,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Type: ${result.type} • ID: ${result.id}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white60),
                              onTap: () => selectThreat(result.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return FutureBuilder<ThreatModel>(
      future: futureThreat,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Error loading threats',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 48),
                SizedBox(height: 16),
                Text(
                  'No threat data available',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        }

        final threat = snapshot.data!;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Card(
              color: const Color(0xFF2D3E50),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Collapsed Header
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                threat.threat!.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: _getRiskColor(threat.riskLevel ?? 'low'),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                threat.riskLevel?.toUpperCase() ?? 'LOW',
                                style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty)
                          Text(
                            _getTruncatedDescription(threat.wikisummary!, 100),
                            style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                          ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                threat.type ?? 'Unknown Type',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: Colors.blue.withOpacity(0.8),
                            ),
                            Row(
                              children: [
                                // NEW: Generate Lesson button
                                
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  onPressed: toggleExpanded,
                                  icon: AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(Icons.expand_more, color: Colors.white),
                                  ),
                                  label: Text(
                                    isExpanded ? 'Less' : 'More',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A252F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expandable Content
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.white24, thickness: 1),
                          const SizedBox(height: 16.0),
                          
                          // Full Description
                          if (threat.wikisummary != null && threat.wikisummary!.isNotEmpty)
                            _buildInfoSection(
                              'Full Description',
                              threat.wikisummary!,
                              Icons.description,
                            ),
                          
                          // Threats Section
                          if (threat.threat != null && threat.threat!.isNotEmpty)
                            _buildInfoSection(
                              'Threats',
                              threat.indicator ?? 'Unknown Indicator',
                              Icons.warning,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          
                          // Categories Section
                          if (threat.category != null && threat.category!.isNotEmpty)
                            _buildInfoSection(
                              'Categories',
                              threat.category!.toString(),
                              Icons.category,
                              color: Colors.green.withOpacity(0.8),
                            ),
                          
                          // Latest News Section
                          if (threat.news != null && threat.news!.isNotEmpty)
                            _buildNewsSection(threat.getLatestNews()),
                          
                          // Timestamps Section
                          _buildTimestampsSection(threat),
                          SizedBox(height: 10.h,),
                          // NEW: Generate Lesson button
                          ElevatedButton.icon(
                                  onPressed: () => generateLessonFromThreat(threat),
                                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                                  label: const Text('Generate Lesson', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A252F).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: const Border(left: BorderSide(color: Colors.blue, width: 4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color ?? Colors.blue, size: 20),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: const TextStyle(color: Colors.white70, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection(List<NewsItem> latestNews) {
    if (latestNews.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A252F).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: const Border(left: BorderSide(color: Colors.orange, width: 4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.article, color: Colors.orange, size: 20),
              SizedBox(width: 8.0),
              Text(
                'Latest News',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          ...latestNews.map((news) => _buildNewsItem(news)),
        ],
      ),
    );
  }

  Widget _buildNewsItem(NewsItem news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3E50).withOpacity(0.7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Channel icon (placeholder as network images might not load in preview)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Icon(Icons.language, color: Colors.white70, size: 12),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  news.channel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                _formatTimestamp(news.stamp),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            news.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton.icon(
            onPressed: () => _launchURL(news.link),
            icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
            label: const Text(
              'Read More',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              minimumSize: const Size(0, 32),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildTimestampsSection(ThreatModel threat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A252F).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: const Border(left: BorderSide(color: Colors.purple, width: 4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.purple, size: 20),
              SizedBox(width: 8.0),
              Text(
                'Timestamps',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          _buildTimestampRow('First Seen', threat.stampAdded),
          _buildTimestampRow('Last Seen', threat.stampSeen),
          _buildTimestampRow('Last Updated', threat.stampUpdated),
        ],
      ),
    );
  }

  Widget _buildTimestampRow(String label, String? timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontSize: 12.0),
            ),
          ),
          Expanded(
            child: Text(
              timestamp ?? 'Unknown',
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  String _getTruncatedDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      Duration difference = DateTime.now().difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
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
}