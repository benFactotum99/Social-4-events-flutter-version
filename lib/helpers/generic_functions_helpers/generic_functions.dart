import 'package:geocoding/geocoding.dart';
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
