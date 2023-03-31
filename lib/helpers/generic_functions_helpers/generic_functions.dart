import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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

bool compareDate(String dateStrStart, String dateStrEnd) {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  DateTime dateTimeStart = dateFormat.parse(dateStrStart);
  DateTime dateTimeEnd = dateFormat.parse(dateStrEnd);

  if (dateTimeStart.isBefore(dateTimeEnd)) {
    //Date/time 1 is earlier than date/time 2
    return true;
  } else if (dateTimeStart.isAfter(dateTimeEnd)) {
    //Date/time 1 is later than date/time 2
    return false;
  } else {
    //Date/time 1 is the same as date/time 2
    return false;
  }
}

bool compareDateFirstEqualNow(String dateStr) {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  DateTime dateTime = dateFormat.parse(dateStr);
  String dateTimeStrNow = dateFormat.format(DateTime.now());
  DateTime dateTimeNow = dateFormat.parse(dateTimeStrNow);

  if (dateTime.isBefore(dateTimeNow)) {
    //Date/time 1 is earlier than date/time 2
    return true;
  } else if (dateTime.isAfter(dateTimeNow)) {
    //Date/time 1 is later than date/time 2
    return false;
  } else {
    //Date/time 1 is the same as date/time 2
    return true;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
