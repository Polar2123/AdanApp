
import 'PrayerSchedule.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIHandler {
  int _currentPrayerIndex = 0;
  


  int getNextPrayerTime(){
    try{
      Map<String, dynamic> json = fetchPrayerTimes();
    }
    catch (Exception){
      return -1;
    }


    final currentTime = DateTime.timestamp();

    while(currentTime.compareTo(DateTime.parse(json['data']['timings'][_currentPrayerIndex])) > 0){
      _currentPrayerIndex++;

    }

  }

  Future<PrayerSchedule> fetchPrayerTimes() async {
    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/albums/1')
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
    

  String _formatAPICall(){
    var timestamp = DateTime.timestamp();
    var day = timestamp.day;
    var month = timestamp.month;
    var year = timestamp.year;

    
    String API = "https://api.aladhan.com/v1/timings/01-01-2025?latitude=51.5194682&longitude=-0.1360365&method=3&shafaq=general&tune=5%2C3%2C5%2C7%2C9%2C-1%2C0%2C8%2C-6&calendarMethod=UAQ";
  }
}