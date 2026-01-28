import 'dart:io';
import 'dart:math' show sin, cos, sqrt, atan2;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeolocatorController extends GetxController {
  Future askingPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return true;
  }

  double toRadians(double degree) {
    return degree * (3.14 / 180);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Radius bumi dalam meter
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;
    return distance;
  }

  bool isWithinRange(double userLatitude, double userLongitude,
      double targetLatitude, double targetLongitude, double maxDistance) {
    double distance = calculateDistance(
      userLatitude,
      userLongitude,
      targetLatitude,
      targetLongitude,
    );

    return distance <= maxDistance;
  }
}
