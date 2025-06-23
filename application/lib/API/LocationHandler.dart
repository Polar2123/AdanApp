import 'package:location/location.dart';

class LocationHandler{
  late LocationData locationData;

  bool serviceEnabled = false;
  PermissionStatus? permissionGranted;

  Future<LocationData> getLocationData() async{
    Location location = Location();



    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      locationData = await location.getLocation();

    }
    else{
      return Future.error('Location Permissions are denied');
    }


    return locationData;
  }

}