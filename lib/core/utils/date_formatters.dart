import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DateFormatters {
  static const dMyDashedTemplate = 'dd-MM-yyyy';
  static const dMyMonthTextTemplate = 'MMMM/dd/yyyy';

  static const dMyDashedDotsTemplate = 'dd.MM.yy';
  static const dMyHmSlashedTimeTemplate = 'dd.MM.yy - HH:mm';
  static const dMyHmFullTimeTemplate = 'dd.MM.yyyy/HH:mm';

  static String? datetimeToSlashedNullable(DateTime? dateTime) {
    final result =
        dateTime != null
            ? DateFormat(dMyDashedTemplate).format(dateTime)
            : null;

    return result;
  }

  static String datetimeToMonthText(DateTime dateTime) {
    return DateFormat(dMyMonthTextTemplate).format(dateTime);
  }

  static List<String> convertTimesTo12HourFormat(List<String> times) {
    return times.map((time) {
      try {
        // Сначала парсим время в формате 'HH:mm' (24-часовой формат)
        final parsedTime = DateFormat('HH:mm').parse(time);

        // Затем преобразуем в 12-часовой формат с AM/PM
        String formattedTime = DateFormat('hh:mm a').format(parsedTime);

        // Убираем пробел между временем и AM/PM
        return formattedTime.replaceAll(RegExp(r'\s'), '');
      } catch (e) {
 
        return '--'; 
      }
    }).toList();
  }

  static String datetimeToSlashed(DateTime dateTime) {
    return DateFormat(dMyDashedTemplate).format(dateTime);
  }

  static String datetimeTodMyHmSTemplate(DateTime dateTime) {
    return DateFormat(dMyHmFullTimeTemplate).format(dateTime);
  }

  static String datetimeddMMyyDotsTemplate(DateTime dateTime) {
    return DateFormat(dMyDashedDotsTemplate).format(dateTime);
  }

  static String datetimeddMMyyyySlashTemplate(DateTime dateTime) {
    return DateFormat(dMyHmFullTimeTemplate).format(dateTime);
  }

  static String? datetimeddMMyyDotsTemplateNullable(DateTime? dateTime) {
    final result =
        dateTime != null
            ? DateFormat(dMyDashedDotsTemplate).format(dateTime)
            : null;

    return result;
  }

  static String formatTimeToString(TimeOfDay timeOfDay) {
    final formatter = NumberFormat('00');
    return '${formatter.format(timeOfDay.hour)} : ${formatter.format(timeOfDay.minute)}';
  }

  static String getCurrentTimeIn12HourFormat() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // Формат: 12:30 PM
  }

  static String formatDurationToHms(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static bool isPrayerTimeNow(
    String prayerTime,
    List<String> prayerTimings,
    List<String> times,
  ) {
    // Получаем текущее время
    final currentTimeParsed = DateFormat(
      'hh:mm a',
    ).parse(DateFormat('hh:mm a').format(DateTime.now()));

    // Находим время молитвы по индексу prayerTimings
    for (int i = 0; i < prayerTimings.length; i++) {
      // Очищаем строки от лишних пробелов
      final formattedPrayerTime = times[i].trim();
      try {
        final prayerTimeParsed = DateFormat(
          'hh:mm a',
        ).parse(formattedPrayerTime);

        // Сравниваем, наступило ли время молитвы
        if (prayerTime == prayerTimings[i] &&
                currentTimeParsed.isAfter(prayerTimeParsed) ||
            currentTimeParsed.isAtSameMomentAs(prayerTimeParsed)) {
          return true;
        }
      } catch (e) {
       
      }
    }
    return false;
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
