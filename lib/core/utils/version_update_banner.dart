import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class VersionUpdateBanner extends StatefulWidget {
  const VersionUpdateBanner({super.key});

  @override
  State<VersionUpdateBanner> createState() => _VersionUpdateBannerState();
}

class _VersionUpdateBannerState extends State<VersionUpdateBanner> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dialogShown) {
      _dialogShown = true;
      _showUpdateDialog();
    }
  }

  Future<void> _showUpdateDialog() async {
    final versionService = GetIt.I<VersionService>();
    final data = await versionService.fetchLatestVersion();
    if (!mounted || data == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.download, color: AppColors.greyshade400),
                SizedBox(width: 8),
                Text(
                  LocaleKeys.updateAvailable.tr(),
                  style: AppTextStyles.bold14,
                ),
              ],
            ),
            content: Text(
              LocaleKeys.updateMessage.tr(),
              style: AppTextStyles.regular10,
              textAlign: TextAlign.start,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.later.tr()),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.simpleGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await versionService.openStore(data);
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: Text(
                  LocaleKeys.updateNow.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // сам виджет ничего не занимает
  }
}
