
import 'package:flutter/cupertino.dart';

import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LocationHandler.dart';
import 'package:location/location.dart';

class APIHandler {
  int _currentPrayerIndex = 0;
  late Map<String, dynamic> _prayerJson;
  late Map<String, dynamic> _ayahJson;
  Future<DateTime> getNextPrayerTime() async{
    try {
      final currentTime = DateTime.now();
      await _fetchPrayerJson(currentTime);
      if (!_validateTime(currentTime)){
        await _fetchPrayerJson(currentTime.add(const Duration(days: 1)));
      }

      return _findNextPrayer(currentTime);
    }
    catch (Exception){
      rethrow;
    }

  }

  DateTime _findNextPrayer(DateTime time){
    var previousPrayer;
    var dayOffset = 0;

    for (var prayer in _prayerJson["data"]["timings"].entries){
      DateTime prayerTime = _formatTime(prayer.value,dayOffset: dayOffset);
      if (previousPrayer != null){
        if (prayerTime.isBefore(previousPrayer)) {
          prayerTime = _formatTime(prayer.value,dayOffset: 1);
        }
      }
      previousPrayer = prayerTime;
      if (time.isBefore(prayerTime)){
        return prayerTime;
      }
    }
    throw Exception('Failed to find prayer times.');
  }

  bool _validateTime(DateTime time){
    DateTime isha = _formatTime(_prayerJson["data"]["timings"]["Isha"]); // get last prayer

    if (time.compareTo(isha) > 0){
      return true;
    }
    else{
      return false;
    }
  }


  DateTime _formatTime(String prayer,{int dayOffset = 0}){
    String time = (prayer + ':').padRight(8,'0'); // Format the date
    List rawDate = _prayerJson["data"]["date"]["gregorian"]["date"].toString().split("-");
    String date = '${rawDate[2]}-${rawDate[1]}-${rawDate[0]}';
    return DateTime.parse('$date $time').add(Duration(days: dayOffset));
  }

  Future<void> _fetchPrayerJson(DateTime time) async {

    final response = await http.get(
        Uri.parse(await _formatPrayerAPICall(time))
    );
    if (response.statusCode == 200) {
      _prayerJson = jsonDecode(response.body) as Map<String,dynamic>;
    }
    else {
      throw Exception('Failed to load prayer times.');
    }

  }

  Future<void> _fetchAyahJson() async{
    final response = await http.get(
      Uri.parse(_formatQuranAPICall())
    );
    if (response.statusCode == 200){
      _ayahJson = jsonDecode(response.body) as Map<String,dynamic>;
    }
    else{
      throw Exception('Failed to load ayah.');
    }

  }

  Future<String> _formatPrayerAPICall(DateTime time) async{
    var timestamp = time;
    var day = timestamp.day.toString().padLeft(2,'0');
    var month = timestamp.month.toString().padLeft(2,'0');
    var year = timestamp.year;

    LocationData locationData = await LocationHandler().getLocationData();

    return "https://api.aladhan.com/v1/timings/$day-$month-$year?latitude=${locationData.latitude}&longitude=${locationData.longitude}&method=3&shafaq=general&tune=5%2C3%2C5%2C7%2C9%2C-1%2C0%2C8%2C-6&calendarMethod=UAQ";
  }


  String _formatQuranAPICall(){
    Random random = Random();
    String _ayahNumber = random.nextInt(6237).toString();
    return 'http://api.alquran.cloud/v1/ayah/$_ayahNumber/en.asad';
  }

  Future<String> getAyah() async{
    try {
      await _fetchAyahJson();
      return '${_ayahJson['data']['number']}: ${_ayahJson['data']['text']}';
    }
    catch (e){
      rethrow;
    }
  }

}