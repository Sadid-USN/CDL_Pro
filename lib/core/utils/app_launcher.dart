import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  static Future<void> launchStore() async {
    try {
      final url = Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.darulasar.cdl_pro' // Используем market:// схему
          : 'https://apps.apple.com'; // Замените на реальный ID

      print('Attempting to launch: $url');
      final uri = Uri.parse(url);

      // Прямая попытка запуска без canLaunchUrl
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print('Direct launch failed, trying alternative: $e');
        // Fallback для Android
        if (Platform.isAndroid) {
          final webUrl = Uri.parse(
              'https://play.google.com/store/apps/details?id=com.darulasar.cdl_pro');
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print('Failed to launch store: $e');
      // Дополнительная обработка ошибки
    }
  }
}


