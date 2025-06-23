
import 'PrayerSchedule.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LocationHandler.dart';
import 'package:location/location.dart';

class APIHandler {
  int _currentPrayerIndex = 0;
  


  int getNextPrayerTime(Map<String,dynamic> json){



    final currentTime = DateTime.timestamp();


    return 1;

  }

  Future<PrayerSchedule> fetchPrayerTimes() async {
    final response = await http.get(
        Uri.parse(await _formatAPICall())
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PrayerSchedule.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      throw Exception('Failed to load prayer times.');
    }
  }
    

  Future<String> _formatAPICall() async{
    var timestamp = DateTime.timestamp();
    var day = timestamp.day.toString().padLeft(2,'0');
    var month = timestamp.month.toString().padLeft(2,'0');
    var year = timestamp.year;

    LocationData locationData = await LocationHandler().getLocationData();

    String API = "https://api.aladhan.com/v1/timings/$day-$month-$year?latitude=${locationData.latitude}&longitude=${locationData.longitude}&method=1&shafaq=general&tune=5%2C3%2C5%2C7%2C9%2C-1%2C0%2C8%2C-6&calendarMethod=UAQ";
    return API;
  }
}