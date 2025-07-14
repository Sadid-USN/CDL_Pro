import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class PolicyPage extends StatelessWidget {
  final PolicyType type;

  const PolicyPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final selectedLang = context.read<SettingsBloc>().state.selectedLang;
    final langCode = SettingsBloc.getLanguageCode(selectedLang);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection(
            type == PolicyType.termsOfUse ? 'termsOfUse' : 'PrivacyPolicy',
          )
          .limit(1)
          .get()
          .then((snap) => snap.docs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Document not found")),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        if (type == PolicyType.termsOfUse) {
          final terms = TermsOfUseModel.fromJson(data);
          final localized = terms.terms[langCode];

          if (localized == null) {
            return const Scaffold(
              body: Center(child: Text("Translation not available")),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(localized.title, style: AppTextStyles.merriweather14),
            ),
            body: Stack(
              children: [
                IgnorePointer(
                  child: Center(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        height: 200,
                        AppLogos.termOfUse,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: localized.sections.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        // 'Effective Date: ${localized.effectiveDate}',
                        child: Text(
                          LocaleKeys.effectiveDate.tr(
                            namedArgs: {
                              "effectiveDate": localized.effectiveDate,
                            },
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }

                    final section = localized.sections[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 1)
                            ElevatedButton(
                              onPressed: () {
                                AppLauncher.openLinkUrl(
                                  AppConstants.tirmsOfUseUrl,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.lightPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                               
                              ),
                              child:  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    LocaleKeys.followTheLink.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h,),

                          // TextButton(
                          //   onPressed: () {
                          //     AppLauncher.openLinkUrl(
                          //       AppConstants.tirmsOfUseUrl,
                          //     );
                          //     // AppLauncher.openLinkUrl(AppConstants.privacyPolicyUrl);
                          //   },
                          //   child: Text('LINK'),
                          // ),
                          Text(
                            section.title,
                            style: AppTextStyles.merriweatherBold14.copyWith(
                              color: AppColors.softBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(section.content),
                             
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          final policy = PrivacyPolicyModel.fromJson(data);
          final localized = policy.localized[langCode];

          if (localized == null) {
            return const Scaffold(
              body: Center(child: Text("Translation not available")),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(localized.title, style: AppTextStyles.merriweather14),
            ),
            body: Stack(
              children: [
                IgnorePointer(
                  child: Center(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        AppLogos.privacyPolicyIcon,

                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: localized.sections.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          LocaleKeys.effectiveDate.tr(
                            namedArgs: {
                              "effectiveDate": localized.effectiveDate,
                            },
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }

                    final section = localized.sections[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                               if (index == 1)
                            ElevatedButton(
                              onPressed: () {
                                AppLauncher.openLinkUrl(
                                  AppConstants.privacyPolicyUrl,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.lightPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                               
                              ),
                              child:  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                  LocaleKeys.followTheLink.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h,),
                          Text(
                            section.title,
                            style: AppTextStyles.merriweatherBold14.copyWith(
                              color: AppColors.softBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(section.content),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
