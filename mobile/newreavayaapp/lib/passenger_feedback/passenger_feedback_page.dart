import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api_connection/api_connection.dart';
import '../authentication/edit_account_screen.dart';
import '../home.dart';
import '../userPreferences/current_user.dart';
import 'package:reavaya_app/pre_home.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  int cleanlinessRating = 1;
  int driverRating = 1;
  String comments = '';
  String buscode = 'T1';
  List<int> ratingOptions = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _rememberCurrentUser.getUserInfo();
  }

  Future<void> submitFeedback() async {
    try {
      final response = await http.post(
        Uri.parse(API.submitFeedback),
        body: {
          'user_id': _rememberCurrentUser.user.userID.toString(),
          'buscode': buscode,
          'cleanliness': cleanlinessRating.toString(),
          'driver': driverRating.toString(),
          'comments': comments,
        },
      );

      if (response.statusCode == 200) {
        // Feedback submitted successfully
        // You can show a confirmation message here
        var resBody = jsonDecode(response.body);
        if (resBody['success']) {
          Fluttertoast.showToast(msg: 'Feedback Submitted Successfully');
          //go to home screen
          Get.to(HomePage());
        } else {
          Fluttertoast.showToast(msg: 'An Error Occurred. Try again.');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Feedback Status not 200: ${response.statusCode}');
      }
    } catch (e) {
      print('ErrorFeedback:: $e');
      Fluttertoast.showToast(msg: 'ErrorFeedback:: $e');
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
              HomePage()),
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
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Feedback form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                      child: Column(
                        children: [
                          const Text(
                            'Rate your experience and give feedback',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          const Text(
                            'Rate the bus driver and cleanliness from 1 for very bad to 5 for very good',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),

                              const Text(
                                'Rate Bus Cleanliness: ',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              DropdownButton<int>(
                                value: cleanlinessRating,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    cleanlinessRating = newValue!;
                                  });
                                },
                                items: ratingOptions.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Rate The Driver: ',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              DropdownButton<int>(
                                value: driverRating,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    driverRating = newValue!;
                                  });
                                },
                                items: ratingOptions.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.directions_bus_filled,
                                color: Colors.black,
                              ),
                              hintText: 'for example: T1 564...',
                              //labelText: 'Bus Code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                buscode = value;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.comment,
                                color: Colors.black,
                              ),
                              hintText: 'comments...',
                              //labelText: 'Comments',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                comments = value;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                submitFeedback();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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

void main() {
  runApp(const MaterialApp(home: FeedbackPage()));
}
