import 'package:flutter/material.dart';
import 'package:ited_study/core/constants/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLaucher {
  Future<void> launchSocialMedia(BuildContext context, String url) async {
    try {
      final success = await launchUrl(Uri.parse(url));
      if (!success) {
        _showError(context, 'No app found to open this link');
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> openFacebook(BuildContext context) async =>
      launchSocialMedia(context, AppUrl.facebook);
  Future<void> openInstagram(BuildContext context) async =>
      launchSocialMedia(context, AppUrl.instagram);
  Future<void> openWhatsApp(BuildContext context) async =>
      launchSocialMedia(context, AppUrl.whatsapp);
  Future<void> openTelegram(BuildContext context) async =>
      launchSocialMedia(context, AppUrl.telegram);
  Future<void> openTiktok(BuildContext context) async =>
      launchSocialMedia(context, AppUrl.tiktok);
}
