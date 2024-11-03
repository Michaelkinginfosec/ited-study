// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/route/route.dart';
import '../../../../core/constants/text_style.dart.dart';
import '../providers/create_school_provider.dart';

class CountryAndSchoolScreen extends ConsumerStatefulWidget {
  const CountryAndSchoolScreen({super.key});

  @override
  ConsumerState<CountryAndSchoolScreen> createState() =>
      CountryAndSchoolScreenState();
}

String? selectedCountry;
String? selectedSchool;

const String kenya = "Kenya";
const String nigeria = "Nigeria";

List<String> countryNames = [kenya, nigeria];

List<String> schoolInNigeria = ["FUTO", "UNIBEN", "UNILAG", "UNIUYO", "AAU"];
List<String> schoolInKenya = ['kenya1', 'kenya2', 'kenya3'];

List<String> getSchoolsByCountry(String? selectedCountry) {
  switch (selectedCountry) {
    case nigeria:
      return schoolInNigeria;
    case kenya:
      return schoolInKenya;
    default:
      return [];
  }
}

class CountryAndSchoolScreenState
    extends ConsumerState<CountryAndSchoolScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<CreateSchoolState>(
      createSchoolNotifierProvider,
      (previous, next) {
        if (next.status == CreateSchooStatus.success) {
          context.push(AppRoutes.signUp);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select your  Country and School",
              style: CustomTextStyles.mediumSubtitleText,
            ),
            CustomSizeBox.largeBox,
            Text(
              "Country",
              style: CustomTextStyles.nameTitle,
            ),
            CustomSizeBox.smallBox,
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: CustomTextStyles.textFieldColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: CustomTextStyles.textFieldColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 5, 45, 1),
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 5, 45, 1),
                    width: 1,
                  ),
                ),
                enabled: true,
                fillColor: CustomTextStyles.textFieldColor,
                filled: true,
              ),
              value: selectedCountry,
              items: countryNames.map((String countryName) {
                return DropdownMenuItem<String>(
                  value: countryName,
                  child: Text(
                    countryName,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (String? newCountry) async {
                setState(() {
                  selectedCountry = newCountry;
                  selectedSchool = null;
                });
              },
            ),
            CustomSizeBox.largeBox,
            Text(
              "University",
              style: CustomTextStyles.nameTitle,
            ),
            CustomSizeBox.smallBox,
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: CustomTextStyles.textFieldColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: CustomTextStyles.textFieldColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 5, 45, 1),
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 5, 45, 1),
                    width: 1,
                  ),
                ),
                enabled: true,
                fillColor: CustomTextStyles.textFieldColor,
                filled: true,
              ),
              value: selectedSchool,
              items:
                  getSchoolsByCountry(selectedCountry).map((String schoolName) {
                return DropdownMenuItem<String>(
                  value: schoolName,
                  child: Text(
                    schoolName,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (String? newSchool) async {
                setState(() {
                  selectedSchool = newSchool;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select your school';
                }
                return null;
              },
            ),
            CustomSizeBox.mediumBox,
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedSchool == null || selectedCountry == null) {
                    context.push(AppRoutes.login);
                  } else {
                    ref
                        .read(createSchoolNotifierProvider.notifier)
                        .createSchool(selectedSchool!, selectedCountry!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTextStyles.loginsignupButtonColor,
                  minimumSize: Size(228, 41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Next",
                  style: CustomTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
