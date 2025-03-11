import 'package:ited_study/core/constants/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLaucher {
  Future<void> launchSocialMedia(String url) async {
    final Uri socialMediaUrl = Uri.parse(url);
    if (await canLaunchUrl(socialMediaUrl)) {
      await launchUrl(socialMediaUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openWhatsApp() {
    launchSocialMedia(AppUrl.whatsapp);
  }
}
