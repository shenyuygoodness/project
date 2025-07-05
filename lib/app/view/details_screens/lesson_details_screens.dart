import 'package:flutter/material.dart';

class LessonDetailsScreens extends StatefulWidget {
  const LessonDetailsScreens({super.key});

  @override
  State<LessonDetailsScreens> createState() => _LessonDetailsScreensState();
}

class _LessonDetailsScreensState extends State<LessonDetailsScreens> {
  final List<Map<String, String>> _content = [
    {'section': 'Introduction', 'text': 'Malware, short for malicious software, encompasses various forms of harmful programs designed to infiltrate and damage computer systems. These programs can range from viruses and worms to Trojans and ransomware, each with unique characteristics and methods of operation. Understanding the different types of malware and their potential impact is crucial for effective cybersecurity.'},
    {'section': 'Prevention', 'text': 'Viruses are self-replicating programs that attach themselves to legitimate files, spreading when the infected file is executed. Worms, on the other hand, are standalone programs that can replicate and spread across networks without requiring a host file. Trojans disguise themselves as harmless software but contain malicious code that can be activated once installed.'},
    {'section': 'Mitigation', 'text': 'Ransomware encrypts a victim\'s files and demands payment for their release. The consequences of malware infections can be severe, ranging from data loss and system instability to financial theft and reputational damage.'},
    {'section': 'Control', 'text': 'Organizations and individuals alike must implement robust security measures, such as antivirus software, firewalls, and regular software updates, to mitigate the risk of malware attacks. Additionally, user awareness and education play a vital role in preventing infections, as many malware programs rely on social engineering tactics to trick users into downloading or executing malicious files.'},
    {'section': 'Conclusion', 'text': ''},
  ];

  String _feedback = 'True';

  void _setFeedback(String value) {
    setState(() {
      _feedback = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A252F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A252F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Understanding Malware',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _content.length,
                itemBuilder: (context, index) {
                  final item = _content[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['section']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          item['text']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Was the content above helpful?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('True', style: TextStyle(color: Colors.white)),
                    value: 'True',
                    groupValue: _feedback,
                    onChanged: (value) => _setFeedback(value!),
                    activeColor: Colors.blue,
                    tileColor: const Color(0xFF2D3E50),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('False', style: TextStyle(color: Colors.white)),
                    value: 'False',
                    groupValue: _feedback,
                    onChanged: (value) => _setFeedback(value!),
                    activeColor: Colors.blue,
                    tileColor: const Color(0xFF2D3E50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle feedback submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}