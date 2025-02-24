import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reavaya_app/Constants/key.dart';
import 'package:reavaya_app/home.dart';
import 'package:reavaya_app/userPreferences/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_connection/api_connection.dart';
import '../authentication/edit_account_screen.dart';
import '../pre_home.dart';

class MakePayment {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  MakePayment({
    required this.ctx,
    required this.price,
    required this.email,
    required this.pointsToAdd,
    required this.onPointsAdded,
  });

  BuildContext ctx;
  int price;
  String email;
  int pointsToAdd;
  PaystackPlugin paystack = PaystackPlugin();
  Function(int) onPointsAdded;

  Future<void> increasePoints() async {
    // Fetch the user ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    SharedPreferences prefse = await SharedPreferences.getInstance();
    String? email = prefse.getString('email');

    // Proceed with the request only if a valid user ID is found
    if (userId != 0) {
      try {
        final response = await http.post(
          Uri.parse(API.updatePoints),
          body: {
            'points_balance': pointsToAdd.toString(),
            'user_id': userId.toString(),
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          print('Points added successfully');
          print('jsonResponse: $jsonResponse');

          int updatedPoints = int.parse(jsonResponse['updatedBalance']);
          print('Updated points: $updatedPoints');

          onPointsAdded(updatedPoints);
          _rememberCurrentUser.pointsBalance.value = updatedPoints;
          /*print('Points added successfully');
          onPointsAdded(pointsToAdd);*/
        } else {
          print('Failed to add points');
        }
      } catch (e) {
        print('An error occurred: $e');
      }
    } else {
      print('No logged-in user found');
      // You can handle the situation here when no logged-in user is found
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardUI() {
    return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  }

  Future<void> initializePlugin() async {
    await paystack.initialize(publicKey: ConstantKey.PAYSTACK_KEY);
  }

  Future<void> chargeCardAndMakePayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    try {
      await initializePlugin();
      Charge charge = Charge()
        ..amount = price * 100
        ..email = email
        ..reference = _getReference()
        ..card = _getCardUI()
        ..currency = 'ZAR';

      // User feedback such as a loading indicator can be initiated here

      CheckoutResponse response = await paystack.checkout(
        ctx,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
      );

      // Stop the loading indicator here

      print('Response $response');

      if (response.status == true) {
        print('Transaction successful');

        // Call the function to increase points
        await increasePoints();

        // Send something to the database here AND/OR Update the UI
      } else {
        print('Transaction failed');
        // Handle the transaction failure here
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

class PointPurchasePage extends StatefulWidget {
  const PointPurchasePage({Key? key}) : super(key: key);

  @override
  _PointPurchasePageState createState() => _PointPurchasePageState();
}

class _PointPurchasePageState extends State<PointPurchasePage> {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  int price = 0;
  late String email; // Email of the user
  int points = 0;

  void updatePoints(int pointsAdded) {
    setState(() {
      points += pointsAdded;
    });
  }

  _PointPurchasePageState() {
    email = _rememberCurrentUser.user.email;
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
    points = _rememberCurrentUser.pointsBalance.value;
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
        title: const Text('Buy Points'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Your current points: $points',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  price = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter the amount of points (1 point = 1 Rand)',
                // labelText: 'Enter the amount of points',
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (price == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter the amount of points')),
                  );
                } else {
                  MakePayment(
                    ctx: context,
                    email: email,
                    price: price,
                    pointsToAdd:
                        price, // Use the entered price as the points to add
                    onPointsAdded: updatePoints, // Include the callback
                  ).chargeCardAndMakePayment();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.blueAccent),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, color: Colors.white),
                    SizedBox(width: 15),
                    Text(
                      'Proceed to payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
}
