import 'package:flutter/material.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  final List<Map<String, Object>> _lessons = [
    {
      'title': 'Understanding Malware',
      'description':
          'Learn about different types of malware and how they can affect your devices.',
      'icon': Icons.shield,
    },
    {
      'title': 'Phishing Awareness',
      'description':
          'Identify and avoid phishing attempts to protect your personal information.',
      'icon': Icons.shield,
    },
    {
      'title': 'Password Security',
      'description':
          'Create strong passwords and manage them effectively to prevent unauthorized access.',
      'icon': Icons.shield,
    },
    {
      'title': 'Social Engineering',
      'description':
          'Recognize and defend against social engineering tactics used by attackers.',
      'icon': Icons.shield,
    },
    {
      'title': 'Data Protection',
      'description':
          'Learn how to protect your sensitive data and maintain your privacy online.',
      'icon': Icons.shield,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A252F),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'CyberShield',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF1A252F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search lessons...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF2D3E50),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton(0, 'All'),
                _buildFilterButton(1, 'Malware'),
                _buildFilterButton(2, 'Phishing'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                return _buildLessonCard(
                    _lessons[index]['title']! as String,
                    _lessons[index]['description']! as String,
                    _lessons[index]['icon']! as IconData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index, String text) {
    final isSelected = _selectedIndex == index;
    return TextButton(
      onPressed: () => _onFilterSelected(index),
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF2D3E50) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Color(0xFF2D3E50)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A252F),
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(String title, String description, IconData icon) {
    return Card(
      color: const Color(0xFF1A252F),
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to lesson content
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3E50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Start →',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Card(
              color: const Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.shield, size: 40.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}