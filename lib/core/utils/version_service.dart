import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionService {
  final Dio dio;

  VersionService(this.dio);

  static const String versionUrl =
      "https://github.com/Sadid-USN/CDL_Pro/blob/main/version.json";

  Future<Map<String, dynamic>?> fetchLatestVersion() async {
    try {
      final response = await dio.get(versionUrl);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print("❌ Version fetch error: $e");
      return null;
    }
  }

  Future<bool> isUpdateRequired() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final data = await fetchLatestVersion();
    if (data == null) return false;

    final latestVersion = data['latest_version'];
    return latestVersion != null && latestVersion != currentVersion;
  }

  Future<void> openStore(Map<String, dynamic> data) async {
    final url = Platform.isAndroid
        ? data['update_url_android']
        : data['update_url_ios'];

    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
