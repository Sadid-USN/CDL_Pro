
import 'package:easy_localization/easy_localization.dart';

class PrayerHelper {
  DateTime? _parsePrayerTime(String prayerTime) {
    final now = DateTime.now();
    if (prayerTime.isEmpty) return null;

    try {
      // Используем формат 'HH:mm' для 24-часового времени
      final parsedTime = DateFormat('HH:mm').parse(prayerTime);
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      print('Ошибка парсинга времени: $prayerTime, $e');
      return null;
    }
  }

 
}
