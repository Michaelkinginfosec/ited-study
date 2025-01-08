import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/widgets/custom_app_bar.dart';
import 'package:ited_study/feature/auth/presentation/providers/activate_app_provider.dart';
import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';
import '../widgets/text_field.dart';

class ActivateAppScreen extends ConsumerStatefulWidget {
  const ActivateAppScreen({super.key});

  @override
  ConsumerState<ActivateAppScreen> createState() => ActivateAppScreenState();
}

class ActivateAppScreenState extends ConsumerState<ActivateAppScreen> {
  final TextEditingController _activationCodeController =
      TextEditingController();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceData = {
        'device': 'Android',
        'model': androidInfo.model,
        'osVersion': androidInfo.version.release,
        'uniqueId': androidInfo.id,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceData = {
        'device': 'iOS',
        'model': iosInfo.utsname.machine,
        'osVersion': iosInfo.systemVersion,
        'uniqueId': iosInfo.identifierForVendor,
      };
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    return deviceData;
  }

  @override
  Widget build(BuildContext context) {
    final activateState = ref.watch(activateAppNotifierProvider);
    ref.listen<ActivateAppState>(
      activateAppNotifierProvider,
      (previous, next) {
        if (!mounted) return;

        if (next.status == ActivateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? "App activated successfully"),
            ),
          );
        } else if (next.status == ActivateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? "Failed to activate app"),
            ),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activate App",
              style: CustomTextStyles.boldTitle,
            ),
            Text(
              'Access full app features',
              style: CustomTextStyles.smallBody,
            ),
            CustomSizeBox.mediumBox,
            Text(
              'Enter your 15 digit activation code to access full app features',
              style: CustomTextStyles.nameTitle,
            ),
            CustomSizeBox.box,
            Text(
              "Activation code",
              style: CustomTextStyles.mediumSubtitle,
            ),
            CustomSizeBox.littleBox,
            CustomTextField(
              obscureText: false,
              keyboardType: TextInputType.number,
              controller: _activationCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your activation code';
                } else if (value.length != 15) {
                  return "Activation code should be 15 digit";
                }
                return null;
              },
            ),
            CustomSizeBox.littleBox,
            activateState.status == ActivateStatus.loading
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            CustomTextStyles.loginsignupButtonColor,
                        minimumSize: Size(228, 41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final deviceData = await getDeviceInfo();
                        final device = deviceData['device'] ?? "";
                        final model = deviceData['model'] ?? "";
                        final osVersion = deviceData['osVersion'] ?? "";
                        final uniqueId = deviceData['uniqueId'] ?? "";
                        ref
                            .read(activateAppNotifierProvider.notifier)
                            .activateApp(
                              _activationCodeController.text.trim(),
                              device,
                              model,
                              osVersion,
                              uniqueId,
                            );
                        _activationCodeController.clear();
                      },
                      child: Text(
                        "Activate",
                        style: CustomTextStyles.buttonText,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _activationCodeController.dispose();
    super.dispose();
  }
}
