// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/presentation/providers/update_user_provider.dart';

import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final updateUser = ref.watch(updateUserNotifierProvider);
    ref.listen<UpdateUserState>(
      updateUserNotifierProvider,
      (previous, next) {
        if (next.status == UpdateuserStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update user success'),
            ),
          );
        } else if (next.status == UpdateuserStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error ?? 'Update user failed')),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomSizeBox.extralBig,
            Text(
              "Edit Profile",
              style: CustomTextStyles.changePassword,
            ),
            Text(
              "Update your profile",
              style: CustomTextStyles.mediumSubtitle,
            ),
            CustomSizeBox.mediumBox,
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.littleBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Department",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _departmentController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your department';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Level",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _levelController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your level';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.extral,
                    updateUser.status == UpdateuserStatus.loading
                        ? Center(child: CircularProgressIndicator.adaptive())
                        : Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CustomTextStyles.loginsignupButtonColor,
                                minimumSize: Size(249, 33),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                ref
                                    .read(updateUserNotifierProvider.notifier)
                                    .updateUser(
                                      _fullNameController.text,
                                      _departmentController.text,
                                      _levelController.text.trim(),
                                    );
                                _departmentController.clear();
                                _levelController.clear();
                                _fullNameController.clear();
                              },
                              child: const Text(
                                'Update',
                                style: CustomTextStyles.buttonText,
                              ),
                            ),
                          ),
                  ],
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
    _fullNameController.dispose();
    _departmentController.dispose();
    _levelController.dispose();
    super.dispose();
  }
}
