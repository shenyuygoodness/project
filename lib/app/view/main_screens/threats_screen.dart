import 'package:flutter/material.dart';
import 'package:project/app/controller/services/threat_api_service.dart';
import 'package:project/app/model/threat_model.dart';

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

  @override
  void initState() {
    super.initState();
    futureThreat = ThreatService().fetchThreats();
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
    super.dispose();
  }

  void refreshData() {
    setState(() {
      futureThreat = ThreatService().fetchThreats();
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
            onPressed: refreshData,
          ),
        ],
      ),
      body: FutureBuilder<ThreatModel>(
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
                  Text(
                    'Error loading threats',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
          
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                        threat.indicator ?? 'Unknown Indicator',
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
                                    ElevatedButton.icon(
                                      onPressed: toggleExpanded,
                                      icon: AnimatedRotation(
                                        turns: isExpanded ? 0.5 : 0.0,
                                        duration: const Duration(milliseconds: 300),
                                        child: const Icon(Icons.expand_more, color: Colors.white),
                                      ),
                                      label: Text(
                                        isExpanded ? 'Show Less' : 'More Details',
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
                                      threat.threat!.toString(),
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
                                  
                                  // Timestamps Section
                                  _buildTimestampsSection(threat),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Navigation Buttons
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement previous functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Previous threat')),
                          );
                        },
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
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement next functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Next threat')),
                          );
                        },
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
          );
        },
      ),
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