// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/text_field.dart';

class ScholarshipScreen extends StatefulWidget {
  const ScholarshipScreen({super.key});

  @override
  State<ScholarshipScreen> createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              CustomSizeBox.extralBig,
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Scholarship",
                  style: CustomTextStyles.changePassword,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Get registered today and stand a chance to be among our lucky winners",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.smallBody,
                ),
              ),
              CustomSizeBox.mediumBox,
              Form(
                key: _formKey,
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
                      "Email",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.littleBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _fullNameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Mat No",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _levelController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Matric Number';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.extral,
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              CustomTextStyles.loginsignupButtonColor,
                          minimumSize: Size(200, 33),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Apply Now!',
                          style: CustomTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
