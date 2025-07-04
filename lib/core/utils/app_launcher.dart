import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  static Future<void> launchStore() async {
    try {
      final url =
          Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.darulasar.cdl_pro'
              : 'https://apps.apple.com';

      print('Attempting to launch: $url');
      final uri = Uri.parse(url);

      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Direct launch failed, trying alternative: $e');
        if (Platform.isAndroid) {
          final webUrl = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.darulasar.cdl_pro',
          );
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print('Failed to launch store: $e');
    }
  }

 static Future<void> contactUs() async {
    const email = 'ulamuyaman@gmail.com';
    const subject = 'App Support';
    
    final gmailUrl = Uri(
      scheme: 'https',
      host: 'mail.google.com',
      path: '/mail/u/0/',
      queryParameters: {
        'view': 'cm',
        'fs': '1',
        'to': email,
        'su': subject,
      },
    );

    final mailtoUrl = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );

    try {
      // Пытаемся открыть Gmail напрямую
      await launchUrl(gmailUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Failed to open Gmail, fallback to mailto: $e');
      // Если Gmail не установлен, используем стандартный mailto
      await launchUrl(mailtoUrl, mode: LaunchMode.externalApplication);
    }
  }

}
