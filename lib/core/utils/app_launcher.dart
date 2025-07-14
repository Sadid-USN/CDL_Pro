import 'dart:io';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class AppLauncher {
  static Future<void> openLinkUrl(String url) async {
    try {
      print('Attempting to launch: $url');
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Failed to launch URL: $e');
    }
  }

  static Future<void> launchStore() async {
    try {
      final url = Platform.isAndroid
          ? AppConstants.googlePlayUrl
          : AppConstants.appleStoreUrl;

      print('Attempting to launch: $url');
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
      await launchUrl(gmailUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Failed to open Gmail, fallback to mailto: $e');
      await launchUrl(mailtoUrl, mode: LaunchMode.externalApplication);
    }
  }
}