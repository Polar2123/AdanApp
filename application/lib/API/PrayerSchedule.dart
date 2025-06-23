
class PrayerSchedule{
  final String Fajr;
  final String Sunrise;
  final String Dhuhr;
  final String Asr;
  final String Sunset;

  PrayerSchedule({required this.Fajr, required this.Sunrise, required this.Dhuhr, required this.Asr, required this.Sunset});

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'Fajr': String Fajr, 'Sunrise': String Sunrise, 'Dhuhr': String Dhuhr, 'Asr': String Asr, 'Sunset': String Sunset} =>
          PrayerSchedule(
              Fajr: Fajr,
              Sunrise: Sunrise,
              Dhuhr: Dhuhr,
              Asr: Asr,
              Sunset: Sunset
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}