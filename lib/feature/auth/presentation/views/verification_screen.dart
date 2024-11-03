// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/core/widgets/custom_app_bar.dart';
import 'package:ited_study/feature/auth/presentation/providers/resend_otp_provider.dart';
import 'package:ited_study/feature/auth/presentation/providers/verify_otp_provider.dart';
import 'package:ited_study/feature/auth/presentation/widgets/otp_field.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String email;
  const VerificationScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();
  final TextEditingController _otp5Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final verifyOTPState = ref.watch(verifyOTPNotifierProvider);
    final resendOTPCodeState = ref.watch(resendOTPNotifierProvider);

    ref.listen<VerifyOTPState>(verifyOTPNotifierProvider,
        (previous, next) async {
      if (next.status == VerifyOTPStatus.success) {
        final snackBar = SnackBar(
          content: Text(
            next.message ?? 'OTP verification successful login to continue',
          ),
        );
        ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
            snackBarController =
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await snackBarController.closed;
        context.pushReplacement(AppRoutes.login);
      } else if (next.status == VerifyOTPStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'OTP verification failed')),
        );
      }
    });

    ref.listen<VerifyOTPState>(verifyOTPNotifierProvider, (previous, next) {
      if (next.status == VerifyOTPStatus.success) {
        final snackBar = SnackBar(
          content: Text(next.message ?? "Verify OTP code sent successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (next.status == VerifyOTPStatus.failure) {
        final snackBar = SnackBar(
          content: Text(next.error ?? "Failed to send OTP  code"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              CustomAppBar(),

              Column(
                children: [
                  Text(
                    "Verification",
                    style: CustomTextStyles.largeBoldTitle,
                  ),
                  CustomSizeBox.extralBig,
                  Image.asset("assets/images/onetimepassword.png"),
                  CustomSizeBox.mediumBox,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      textAlign: TextAlign.center,
                      "We have sent the verification code to your email address",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OTPField(
                        controller: _otp1Controller,
                      ),
                      OTPField(
                        controller: _otp2Controller,
                      ),
                      OTPField(
                        controller: _otp3Controller,
                      ),
                      OTPField(
                        controller: _otp4Controller,
                      ),
                      OTPField(
                        controller: _otp5Controller,
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomSizeBox.mediumBox,
                  resendOTPCodeState.status == ResendOTPStatus.loading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : InkWell(
                          onTap: () {
                            ref
                                .read(resendOTPNotifierProvider.notifier)
                                .resendOTPCode(widget.email);
                          },
                          child: Container(
                            width: 191,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Resend",
                                style: CustomTextStyles.smallBody,
                              ),
                            ),
                          ),
                        ),
                  CustomSizeBox.extral,
                  verifyOTPState.status == VerifyOTPStatus.loading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : InkWell(
                          onTap: () {
                            final otp = _otp1Controller.text +
                                _otp2Controller.text +
                                _otp3Controller.text +
                                _otp4Controller.text +
                                _otp5Controller.text;

                            ref
                                .read(verifyOTPNotifierProvider.notifier)
                                .verifyOTP(otp);
                          },
                          child: Container(
                            width: 263,
                            height: 61,
                            decoration: BoxDecoration(
                              color: CustomTextStyles.loginsignupButtonColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: CustomTextStyles.smallBody,
                              ),
                            ),
                          ),
                        ),
                ],
              ),

              // SizedBox(
              //   height: 60,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    _otp5Controller.dispose();
    super.dispose();
  }
}
