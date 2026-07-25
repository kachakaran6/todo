import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';

/// Professional service handling Android Play Store native In-App Updates
/// and cross-platform In-App Rating & Review prompts.
class PlayStoreService {
  PlayStoreService._();

  static final InAppReview _inAppReview = InAppReview.instance;

  /// Checks Google Play Store for new application updates and triggers
  /// the Play Store native bottom sheet update flow.
  ///
  /// Safe to call on app startup — gracefully handles non-Android platforms
  /// and sideloaded dev builds (which lack Play Store installation tokens).
  static Future<void> checkForUpdate({bool forceImmediate = true}) async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed && forceImmediate) {
          // Triggers Google Play Store native bottom sheet / full overlay immediate update
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Triggers flexible background update, then completes
          final status = await InAppUpdate.startFlexibleUpdate();
          if (status == AppUpdateResult.success) {
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      }
    } catch (e) {
      // Sideloaded debug/release builds or offline devices may throw an exception
      debugPrint('[PlayStoreService] Update check skipped or unhandled: $e');
    }
  }

  /// Triggers native In-App Review dialog or opens the Play Store app listing.
  static Future<void> requestReview({bool forceStoreListing = false}) async {
    try {
      if (forceStoreListing) {
        await _inAppReview.openStoreListing(
          appStoreId: 'com.taskmitra.application',
        );
        return;
      }

      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing(
          appStoreId: 'com.taskmitra.application',
        );
      }
    } catch (e) {
      debugPrint('[PlayStoreService] In-App Review error: $e');
    }
  }
}
