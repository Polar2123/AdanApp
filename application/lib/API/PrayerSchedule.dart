
class PrayerSchedule{
  final Map<String,dynamic> data;


  PrayerSchedule({required this.data});

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'data': Map<String,dynamic> data} =>
          PrayerSchedule(
              data: data
          ),
      _ => throw const FormatException('Failed to load prayer times.'),
    };
  }

}