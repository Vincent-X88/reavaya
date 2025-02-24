import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_connection/api_connection.dart';
import '../home.dart';
import '../pre_home.dart';
import '../userPreferences/current_user.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final response = await http.get(Uri.parse(API.notifications));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  void _navigateToLoginScreen(BuildContext context) {
    // Call the logout method and navigate back to the Login screen
    CurrentUser().logout();
    _rememberCurrentUser.updateUserInfo();
    Get.to(const PreHomeScreen());
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage()), // Replace 'HomeScreen' with the actual name of your home screen class
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'images/Logo.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _navigateToLoginScreen(context),
            child: const Text(
              'Logout',
            ),
          ),
        ],
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Display loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return InkWell(
                  onTap: () {
                    // Show full body when notification title is tapped
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                notification['notice'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text(notification['title']),
                    subtitle: Text(notification['notice']),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _navigateToHomeScreen(context);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationModel {
  final int notification_id;
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.notification_id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notification_id: json['notification_id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
