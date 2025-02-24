import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/api_connection.dart';
import '../authentication/edit_account_screen.dart';
import '../pre_home.dart';
import '../home.dart';
import '../userPreferences/current_user.dart';

class SecondScanPage extends StatefulWidget {
  const SecondScanPage({super.key});

  @override
  _SecondScanPageState createState() => _SecondScanPageState();
}

class _SecondScanPageState extends State<SecondScanPage> {
  String result = "";
  String? firstScanData; // Variable to store data from the first scan
  String? secondScanData; // Variable to store data from the second scan
  String originDestination = ""; // Store origin-destination fetched from the server
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  int _userPoints = 0;
  static const int MIN_POINTS_REQUIRED = 20;
  Future<void>? _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _rememberCurrentUser.getUserInfo();
    // Initialize the controllers with the existing user data
    //pointsController.text = _rememberCurrentUser.user.pointsBalance.toString();
  }

  Future<void> _scanQR() async {
    // Request camera permission
    // Fetch the user ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    //print(userId);

    // Check funds before proceeding with scan
    if (_userPoints!< MIN_POINTS_REQUIRED) {
      _showSnackbar("Insufficient funds to start the trip");
      return; // Exit function early
    }

    if (await Permission.camera.request().isGranted) {
      try {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          result = cameraScanResult!;
          if (firstScanData == null) {
            firstScanData = result;
          } else {
            secondScanData = result;
            if (secondScanData != null) {
              DateTime timestamp = DateTime.now();
              // String userID = "1"; // Replace with the actual user ID
              _sendQRCodeToServer(timestamp, userId, originDestination);
              _showPaymentSuccessfulDialog();
            }
          }
        });
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      // Handle permission denial
      print('Camera permission denied');
    }
  }

  Future<void> _showPaymentSuccessfulDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Payment Successful',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Thank you for your payment. Have a safe journey!',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Reset the scanned data to null
                      firstScanData = null;
                      secondScanData = null;
                      result = ""; // Reset the result message
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to send the scanned QR code to the server
  Future<void> _sendQRCodeToServer(
      DateTime timestamp, int userID, String originDestination) async {
    if (firstScanData != null && secondScanData != null) {
      const serverUrl = API.qrScanner;

      try {
        final response = await http.post(Uri.parse(serverUrl), body: {
          'firstScannedCode': firstScanData!,
          'secondScannedCode': secondScanData!,
          'timestamp': timestamp.toIso8601String(),
          'userID': userID.toString(),
          'originDestination': originDestination,
        });

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);

          print('JSON decoded: $jsonResponse');

          final int pointsDeducted = jsonResponse['pointsDeducted'];
          final int updatedBalance = int.parse(jsonResponse['updatedBalance']);

          print('Points deducted: $pointsDeducted');
          print('Updated balance: $updatedBalance');

          _showPointsDialog(pointsDeducted.toString());

          _rememberCurrentUser.pointsBalance.value = updatedBalance;

          setState(() {
            //_rememberCurrentUser.user.pointsBalance = updatedBalance;
            //_userPoints = updatedBalance; // this line will make sure the widget reflects the latest balance.
            result = "QR codes are valid. Points: $pointsDeducted";
          });

        } else {
          setState(() {
            result = "Error: Unable to connect to the server.";
          });
        }
        /*if (response.statusCode == 200) {
          String points = response.body;
          setState(() {
            result = "QR codes are valid. Points: $points";
          });
          _showPointsDialog(points);
        } else {
          setState(() {
            result = "Error: Unable to connect to the server.";
          });
        }*/
      } catch (e) {
        setState(() {
          result = "Error: $e";
        });
      }
    }
  }

  // Function to show the points in a dialog
  Future<void> _showPointsDialog(String points) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Points Deducted',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('$points points deducted.',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _showPaymentSuccessfulDialog(); // Show the "Payment Successful" dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show a snackbar with a given message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
              HomePage()),
    );
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

          return Scaffold(
            appBar: AppBar(
              leading: Image.asset(
                'images/Logo.png',
                height: 30,
                fit: BoxFit.contain,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(EditAccountScreen(user: _rememberCurrentUser.user));
                  },
                  icon: const Icon(Icons.account_box),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToLoginScreen(context),
                  child: const Text(
                    'Logout',
                  ),
                ),
              ],
              title: const Text('Passenger Feedback'),
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white, // Set the background color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (firstScanData == null)
                      const Text(
                        "Please scan the QR code.",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        "Have you arrived at your destination? Please scan the Qr code.",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      result,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                _scanQR(); // calling a function when the user clicks on the button
              },
              label: firstScanData == null ? const Text("Scan") : const Text("Scan"),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            bottomNavigationBar: BottomAppBar(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _navigateToHomeScreen(context); // Navigate to the home screen
                    },
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
