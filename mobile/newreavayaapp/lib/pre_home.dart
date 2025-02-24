import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reavaya_app/authentication/register_screen.dart';
import 'authentication/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: PreHomeScreen(),
    );
  }
}

class PreHomeScreen extends StatelessWidget {
  const PreHomeScreen({super.key});

  /*void _showBusRouteImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.asset(
          'images/Official_Rea_Vaya_Route_Map.jpg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }*/

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
            onPressed: () {
              Get.to(const RegisterScreen());
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(const LoginScreen());
            },
            child: const Text('Login'),
          ),
        ],
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
          height: 800,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ReaVaya3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Easiest way to catch a ride',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ride with us, arrive with ease',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 16),
                  ),
                  child: const Text('Start A Ride With Us'),
                ),
                const SizedBox(height: 30),
                const Text(
                  '50+',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'stations available',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // Add other widgets as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
