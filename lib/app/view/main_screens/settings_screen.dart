// import 'package:flutter/material.dart';

// class Settings extends StatefulWidget {
//   const Settings({super.key});

//   @override
//   State<Settings> createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _threatAlerts = false;
  bool _vulnerabilityUpdates = false;
  bool _dailyDigest = false;
  bool _offlineMode = false;
  bool _darkTheme = false;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeNotifications();
  // }

  // Future<void> _initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   final InitializationSettings initializationSettings =
  //       const InitializationSettings(android: initializationSettingsAndroid);
  //   await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //   await _requestNotificationPermission();
  // }

  // Future<void> _requestNotificationPermission() async {
  //   if (await Permission.notification.isDenied) {
  //     await Permission.notification.request();
  //   }
  // }

  // Future<void> _showNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails('threat_channel', 'Threat Alerts',
  //           importance: Importance.max, priority: Priority.high, playSound: true, enableVibration: true);
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await _flutterLocalNotificationsPlugin.show(
  //       0, title, body, platformChannelSpecifics);
  // }

  // void _updateNotificationSettings() {
  //   // No need to call _showNotification here, as it's meant for explicit triggers.
  //   // The switch state itself reflects the user's preference.
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkTheme ? const Color(0xFF1A252F) : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: _darkTheme ? const Color(0xFF1A252F) : Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            // SwitchListTile(
            //   title: const Text('Threat Alerts'),
            //   subtitle: const Text('Receive alerts for new threat intelligence reports.'),
            //   value: _threatAlerts,
            //   onChanged: (value) {
            //     setState(() {
            //       _threatAlerts = value;
            //       if (value) _updateNotificationSettings();
            //     });
            //   },
            //   activeColor: Colors.blue,
            // ),
            // SwitchListTile(
            //   title: const Text('Vulnerability Updates'),
            //   subtitle: const Text('Get notified about critical security vulnerabilities.'),
            //   value: _vulnerabilityUpdates,
            //   onChanged: (value) {
            //     setState(() {
            //       _vulnerabilityUpdates = value;
            //       // if (value) _updateNotificationSettings(); // No need to call this here
            //     });
            //   },
            //   activeColor: Colors.blue,
            // ),
            // SwitchListTile(
            //   title: const Text('Daily Digest'),
            //   subtitle: const Text('Receive daily summaries of the latest threat landscape.'),
            //   value: _dailyDigest,
            //   onChanged: (value) {
            //     setState(() {
            //       _dailyDigest = value;
            //       // if (value) _updateNotificationSettings(); // No need to call this here
            //     });
            //   },
            //   activeColor: Colors.blue,
            // ),
            const SizedBox(height: 24.0),
            const Text(
              'General',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('Offline Mode'),
              subtitle: const Text(
                'Access threat intelligence data even without an internet connection.',
              ),
              value: _offlineMode,
              onChanged: (value) {
                setState(() {
                  _offlineMode = value;
                });
              },
              activeColor: Colors.blue,
            ),
            // SwitchListTile(
            //   title: const Text('Theme'),
            //   subtitle: const Text(
            //     'Switch between light and dark themes for optimal viewing.',
            //   ),
            //   value: _darkTheme,
            //   onChanged: (value) {
            //     setState(() {
            //       _darkTheme = value;
            //     });
            //   },
            //   activeColor: Colors.blue,
            // ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        // TODO: Save settings
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Save',
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page Content Here')),
    );
  }
}
