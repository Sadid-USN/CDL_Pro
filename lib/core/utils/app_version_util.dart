import 'package:package_info_plus/package_info_plus.dart';

class AppVersionUtil {
  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '1.0.0'; // fallback version
    }
  }
}
