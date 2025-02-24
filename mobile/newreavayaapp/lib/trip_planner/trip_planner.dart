import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:reavaya_app/userPreferences/current_user.dart';
import 'package:intl/intl.dart';
import 'bus_map_screen.dart';

import '../api_connection/api_connection.dart';
import 'package:reavaya_app/pre_home.dart';
import '../authentication/edit_account_screen.dart';
import '../home.dart';

class DestinationApp extends StatelessWidget {
  const DestinationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Destination Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DestinationScreen(),
    );
  }
}

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({Key? key}) : super(key: key);

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  GoogleMapPolyline googleMapPolyline =
  GoogleMapPolyline(apiKey: '');
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  String? selectedPickup;
  String? selectedDestination;

  DateTime? selectedDate;

  List<String> pickupPoints = [];
  List<String> destinations = [];
  List<Bus> buses = [];
  LatLng? busLiveLocation;

  Timer? busMovementTimer; // Timer for simulating bus movement
  Random random = Random(); // Random number generator

  bool isBusTapped = false;

  double longitude = 0;
  double latitude = 0;

  dynamic data; // Declare the data variable at a higher scope

  Set<Polyline> mapPolylines = {}; // Initialize with an empty set

  @override
  void initState() {
    super.initState();
    _rememberCurrentUser.getUserInfo();
    fetchPickupPoints();
    fetchDestinations();
    fetchDefaultLocation();
    selectedPickup = pickupPoints.isNotEmpty ? pickupPoints[0] : null;
    selectedDestination = destinations.isNotEmpty ? destinations[0] : null;

    // Initialize busLiveLocation with a default location
    busLiveLocation = const LatLng(-26.1820, 27.9992);

    // Start the timer to simulate bus movement
    startBusMovementTimer();
  }

  // Function to start the bus movement timer
  void startBusMovementTimer() {
    // Define the duration for updating bus location (e.g., every 5 seconds)
    const Duration updateInterval = Duration(seconds: 2);

    // Create a periodic timer
    busMovementTimer = Timer.periodic(updateInterval, (timer) {
      // Call simulateBusMovement to update busLiveLocation
      simulateBusMovement();
    });
  }

  // Function to simulate bus movement with random coordinates
  void simulateBusMovement() {
    const double moveDelta = 0.0001; // Adjust the delta as needed
    final double newLatitude =
        busLiveLocation!.latitude + (random.nextDouble() * 2 - 1) * moveDelta;
    final double newLongitude =
        busLiveLocation!.longitude + (random.nextDouble() * 2 - 1) * moveDelta;

    setState(() {
      busLiveLocation = LatLng(newLatitude, newLongitude);
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    busMovementTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchAndDrawRoute(
      LatLng pickupCoordinates, LatLng destinationCoordinates) async {
    List<LatLng> polylineCoordinates =
        await googleMapPolyline.getCoordinatesWithLocation(
          origin: pickupCoordinates,
          destination: destinationCoordinates,
          mode: RouteMode.driving,
        ) ??
            [];

    setState(() {
      mapPolylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          points: polylineCoordinates,
        ),
      );
    });
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    return picked; // Return the selected date
  }

  Future<void> fetchBuses(
      String pickup, String destination, DateTime selectedDate) async {
    final formattedDate =
        "${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}";
    final response = await http.get(
      Uri.parse(
          "${API.fetchCoordinates}?pickup=$pickup&destination=$destination&date=$formattedDate"),
    );
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      print('Received data: $data'); // Print the received data for debugging
      final Map<String, dynamic> pickupCoordinates = data['pickupCoordinates'];
      final Map<String, dynamic> destinationCoordinates =
      data['destinationCoordinates'];

      try {
        final double pickupLatitude =
        double.parse(pickupCoordinates['latitude']);
        final double pickupLongitude =
        double.parse(pickupCoordinates['longitude']);
        final double destinationLatitude =
        double.parse(destinationCoordinates['latitude']);
        final double destinationLongitude =
        double.parse(destinationCoordinates['longitude']);

        drawRouteOnMap(
          LatLng(pickupLatitude, pickupLongitude),
          LatLng(destinationLatitude, destinationLongitude),
        );
      } catch (e) {
        print(
            'Error parsing coordinates: $e'); // Print any parsing errors for debugging
      }
    }
  }

  void drawRouteOnMap(LatLng pickupCoordinates, LatLng destinationCoordinates) {
    setState(() {
      mapPolylines.clear(); // Clear previous polylines
    });
    fetchAndDrawRoute(pickupCoordinates, destinationCoordinates);
  }

  Future<void> fetchPickupPoints() async {
    final response = await http.get(
        Uri.parse(API.pickupPoints));
    if (response.statusCode == 200) {
      setState(() {
        pickupPoints =
            (json.decode(response.body) as List<dynamic>).cast<String>();
      });
    }
  }

  Future<void> fetchDestinations() async {
    final response = await http.get(
        Uri.parse(API.destinations));
    if (response.statusCode == 200) {
      setState(() {
        destinations =
            (json.decode(response.body) as List<dynamic>).cast<String>();
      });
    }
  }

  void _onPickupChanged(String? newValue) {
    setState(() {
      selectedPickup = newValue;
    });
  }

  Future<void> fetchDefaultLocation() async {
    final url = Uri.parse(API.fetchCoordinates);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        longitude = data['longitude'];
        latitude = data['latitude'];

        print('Longitude: $longitude');
        print('Latitude: $latitude');
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onBusTapped(LatLng location) {
    simulateBusMovement();
    setState(() {
      isBusTapped = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BusMapScreen(
            initialBusLocation:
            LatLng(-26.1820, 27.9992), // Pass the current bus location
            destinationCoordinates: LatLng(-26.2052, 28.0374)
          // Provide the value here
        ),
      ),
    );
    LatLng destinationCoordinates =
    const LatLng(-26.2052, 28.0374); // Set the destination coordinates
    fetchAndDrawRoute(busLiveLocation!, destinationCoordinates);
  }

  void _onDestinationChanged(String? newValue) {
    setState(() {
      selectedDestination = newValue;
    });
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
            onPressed: () => _navigateToLoginScreen(),
            child: const Text(
              'Logout',
            ),
          ),
        ],
        title: const Text('Destination selector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Choose your pickup point:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedPickup,
              onChanged: _onPickupChanged,
              items: pickupPoints.map((String pickup) {
                return DropdownMenuItem<String>(
                  value: pickup,
                  child: Text(pickup),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose your destination:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedDestination,
              onChanged: _onDestinationChanged,
              items: destinations.map((String destination) {
                return DropdownMenuItem<String>(
                  value: destination,
                  child: Text(destination),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedPickup != null && selectedDestination != null) {
                  final selectedDate = await _selectDate(
                      context); // Show date picker and wait for user input

                  if (selectedDate != null) {
                    setState(() {
                      this.selectedDate = selectedDate; // Update the selectedDate
                    });
                  }

                  await fetchBuses(
                      selectedPickup!, selectedDestination!, selectedDate!);

                  if (data != null && data['buses'] != null) {
                    setState(() {
                      // Update the buses list after fetching data
                      buses = (data['buses'] as List<dynamic>)
                          .map<Bus>((bus) => Bus.fromJson(bus))
                          .toList();
                    });
                  }
                }
              },
              child: const Text('Search Buses'),
            ),

            if (selectedDate != null)
              Column(
                children: [
                  Text(
                    'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (selectedPickup != null &&
                selectedDestination != null &&
                selectedDate != null)
              const Text(
                'Ride Cost: 10 points', // Format the cost to 2 decimal places
                style: TextStyle(fontSize: 16,
                    color: Colors.green),

              ),
            Expanded(
              child: Column(
                children: [
                  if (buses.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: buses.length,
                        itemBuilder: (context, index) {
                          final bus = buses[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text('Bus Name: ${bus.name}'),
                              subtitle:
                              Text('Departure Time: ${bus.departureTime}'),
                              onTap: () {
                                busLiveLocation =
                                const LatLng(-26.1820, 27.9992);
                                if (busLiveLocation != null) {
                                  setState(() {
                                    _onBusTapped(
                                        const LatLng(-26.1820, 27.9992));
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        buses.isEmpty ? 'No buses found.' : '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
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

class Bus {
  final String name;
  final String departureTime;

  Bus({required this.name, required this.departureTime});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      name: json['name'],
      departureTime: json['departureTime'],
    );
  }
}
