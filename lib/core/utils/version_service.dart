import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionService {
  final Dio dio;

  VersionService(this.dio);

  static const String versionUrl =
      "https://raw.githubusercontent.com/Sadid-USN/CDL_Pro/main/version.json";

  Future<Map<String, dynamic>?> fetchLatestVersion() async {
    try {
      final response = await dio.get(versionUrl);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.data);
        return decoded as Map<String, dynamic>;
      }
      return null;
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

    final latestVersion = data['latest_version'] as String?;
    if (latestVersion == null) return false;

    print("Current version: $currentVersion, Latest: $latestVersion");

    return latestVersion != currentVersion;
  }

  Future<void> openStore(Map<String, dynamic> data) async {
    final url =
        Platform.isAndroid
            ? data['update_url_android']
            : data['update_url_ios'];

    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
