import 'package:location/location.dart';

class LocationHandler{
  double? _longitude;
  double? _latitude;

  bool serviceEnabled = false;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  Future<LocationData> _getLocationData() async{
    Location location = Location();



    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return 0;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return 0;
      }
    }

    locationData = await location.getLocation();

    return locationData;
  }

}