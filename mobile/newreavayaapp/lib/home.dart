import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reavaya_app/Payment/point_purchase_page.dart';
import 'package:reavaya_app/passenger_feedback/passenger_feedback_page.dart';
import 'package:reavaya_app/pre_home.dart';
import 'package:reavaya_app/qr_scanner/second_scan.dart';
import 'package:reavaya_app/trip_planner.dart';
import 'package:reavaya_app/userPreferences/current_user.dart';
import 'authentication/edit_account_screen.dart';
import 'notifications/notifications.dart';
import '../../api_connection/api_connection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

void main() {
  Get.put(CurrentUser());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reavaya App',
      home: HomePage(),
      getPages: [
        GetPage(name: '/pointPurchase', page: () => const PointPurchasePage()),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;
  //int? _userPoints; // Store the user's points here
  int _userPoints = 0;
  Future<void>? _userInfoFuture;
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _rememberCurrentUser.getUserInfo();    _pageController = PageController(initialPage: _currentIndex);
    //_loadUserPoints();
  }

  /*Future<void> _loadUserPoints() async {
    try {
      // Fetch the user's points from the PHP script
      final userId = _rememberCurrentUser.user.userID;
      final url = Uri.parse('${API.fetchPoints}?user_id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          setState(() {
            _userPoints = int.parse(jsonData['points_balance']);
          });
        } else {
          // Handle error
          print(jsonData['message']);
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error fetching user points: $e');
    }
  }*/

  void _downloadBusRoutes(BuildContext context) {
    // Replace 'your_existing_pdf_url.pdf' with the actual URL or file path of your PDF
    final pdfUrl = 'C:/Users/RETHABILE/Downloads/your_existing_pdf.pdf';

    launchUrl(pdfUrl as Uri);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error loading user info')),
          );
        } else {
    _userPoints = _rememberCurrentUser.user.pointsBalance ?? 0;
    _rememberCurrentUser.pointsBalance.value = _rememberCurrentUser.user.pointsBalance ?? 0;
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              toolbarHeight: 60,
              leading: Image.asset(
                'images/Logo.png',
                height: 30,
                fit: BoxFit.contain,
              ),
              actions: [
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                        child: Text(
                        'Points: ${_rememberCurrentUser.pointsBalance.value}',
                        style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'Points: $_userPoints',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ), */
                ElevatedButton(
                  onPressed: () => _navigateToLoginScreen(context),
                  child: const Text(
                    'Logout',
                  ),
                ),
              ],
              title: const Text('Home'),
            )
          : null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/ReaVaya3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome ${_rememberCurrentUser.user.userName}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const Text(
                        'Easiest way to catch a ride',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const Text(
                        'Ride with us, arrive with ease',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const PointPurchasePage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Buy Points'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const SecondScanPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Start A Ride'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const DestinationScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Plan A Trip'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const FeedbackPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Give Feedback'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _downloadBusRoutes(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                              'Download Bus Routes'), // Updated button text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const PointPurchasePage(),
              const NotificationsPage(),
              EditAccountScreen(user: _rememberCurrentUser.user),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        activeColor: CupertinoColors.activeBlue,
        backgroundColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, color: Colors.white),
            activeIcon: Icon(CupertinoIcons.home, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle, color: Colors.white),
            activeIcon: Icon(CupertinoIcons.money_dollar_circle,
                color: CupertinoColors.activeOrange),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text, color: Colors.white),
            activeIcon: Icon(CupertinoIcons.chat_bubble_text,
                color: CupertinoColors.activeOrange),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled, color: Colors.white),
            activeIcon: Icon(CupertinoIcons.profile_circled,
                color: CupertinoColors.activeOrange),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _downloadBusRoutes(context);
        },
        child: Icon(Icons.cloud_download),
      ),
    );
  }
},
);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
  }

  void _navigateToLoginScreen(BuildContext context) {
    CurrentUser().logout();
    _rememberCurrentUser.updateUserInfo();
    Get.to(const PreHomeScreen());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
