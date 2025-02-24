import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class BusETA {
  late final DateTime estimatedArrivalTime;
  late Duration remainingTime;

  BusETA({
    required DateTime estimatedArrivalTime,
  }) {
    this.estimatedArrivalTime = estimatedArrivalTime;
    updateRemainingTime();
  }

  void updateRemainingTime() {
    final now = DateTime.now();
    if (estimatedArrivalTime.isAfter(now)) {
      remainingTime = estimatedArrivalTime.difference(now);
    } else {
      remainingTime = Duration.zero;
    }
  }
}

class BusMapScreen extends StatefulWidget {
  final LatLng initialBusLocation;
  final LatLng destinationCoordinates;

  const BusMapScreen({
    Key? key,
    required this.initialBusLocation,
    required this.destinationCoordinates,
  }) : super(key: key);

  @override
  _BusMapScreenState createState() => _BusMapScreenState();
}

class _BusMapScreenState extends State<BusMapScreen>
    with TickerProviderStateMixin {
  late LatLng busLocation;
  late Timer busMovementTimer;
  Set<Marker> markers = {};
  List<LatLng> routeCoordinates = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  late BusETA busETA;

  @override
  void initState() {
    super.initState();
    busLocation = widget.initialBusLocation;
    startBusMovementTimer();
    fetchRoute();
    loadCustomBusIcon();
    // Initialize busETA with an estimated arrival time (adjust as needed)
    busETA = BusETA(
      estimatedArrivalTime: DateTime.now().add(Duration(hours: 240)),
    );
    // Start a timer to update the remaining time every second
    const Duration updateInterval = Duration(seconds: 1);
    busMovementTimer = Timer.periodic(updateInterval, (_) {
      setState(() {
        busETA.updateRemainingTime();
      });
    });
  }

  @override
  void dispose() {
    busMovementTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void startBusMovementTimer() {
    const Duration updateInterval = Duration(seconds: 5);

    busMovementTimer = Timer.periodic(updateInterval, (timer) {
      setState(() {
        if (_currentIndex < routeCoordinates.length - 1) {
          _currentIndex++;
          busLocation = routeCoordinates[_currentIndex];
        } else {
          timer.cancel();
        }
      });
    });
  }

  void loadCustomBusIcon() async {
    final ByteData byteData = await rootBundle.load('images/busIcon.jpg');
    final Uint8List uint8List = byteData.buffer.asUint8List();

    final BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(uint8List);

    markers.add(Marker(
      markerId: MarkerId('bus_marker'),
      position: busLocation,
      icon: customIcon,
    ));

    setState(() {});
  }

  void fetchRoute() async {
    final polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCOyYjgQSM-cxkB5nmtvKOeh4cMPAfrc0M',
      PointLatLng(widget.initialBusLocation.latitude,
          widget.initialBusLocation.longitude),
      PointLatLng(widget.destinationCoordinates.latitude,
          widget.destinationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        routeCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _controller = AnimationController(
          duration: Duration(seconds: 240),
          vsync: this,
        );

        _animation = Tween<double>(
          begin: 0,
          end: routeCoordinates.length.toDouble(),
        ).animate(_controller)
          ..addListener(() {
            final index = _animation.value.toInt();
            if (index >= 0 && index < routeCoordinates.length) {
              setState(() {
                _currentIndex = index;
                busLocation = routeCoordinates[_currentIndex];
                markers.clear();
                markers.add(Marker(
                  markerId: MarkerId('bus_marker'),
                  position: busLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ));
              });
            }
          });

        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String etaText =
        'Estimated Arrival Time: ${formatDuration(busETA.remainingTime)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.initialBusLocation,
                zoom: 14,
              ),
              markers: markers,
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  color: Colors.blue,
                  points: routeCoordinates,
                  width: 5,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(etaText),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
