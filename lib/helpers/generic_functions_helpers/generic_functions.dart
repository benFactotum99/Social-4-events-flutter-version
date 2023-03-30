import 'package:geocoding/geocoding.dart';

String getFileExtension(String fileName) {
  try {
    return "." + fileName.split('.').last;
  } catch (e) {
    return "";
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future<Map<String, dynamic>> getCoordinates(String address) async {
  List<Location> locations = await locationFromAddress(address);

  final lat = locations[0].latitude;
  final lng = locations[0].longitude;

  return {'lat': lat, 'lng': lng};
}
