import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocation {
  Future<Map<String, dynamic>> currentLocation() async {
    Position p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      p.latitude,
      p.longitude,
    );

    Placemark pm = placemarks.first;

    String address =
        "${pm.street}, ${pm.locality}, ${pm.postalCode}, ${pm.country}";

    return {'lat': p.latitude, 'lng': p.longitude, 'address': address};
  }

  Future<Map<String, dynamic>> offlineLocation() async {
    Position p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    return {'lat': p.latitude, 'lng': p.longitude};
  }
}
