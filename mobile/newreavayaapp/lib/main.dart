import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reavaya_app/trip_planner.dart';

import 'package:reavaya_app/pre_home.dart';

import 'package:reavaya_app/authentication/login_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rea Vaya App',
      home: PreHomeScreen(),
      getPages: [
        //   GetPage(name: '/pointPurchase', page: () => const PointPurchasePage()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reavaya App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/pointPurchase');
              },
              child: const Text('Purchase Points'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //Get.to(const TripPlanner());
              },
              child: const Text('Trip Planner'),
            ),
          ],
        ),
      ),
    );
  }
}
