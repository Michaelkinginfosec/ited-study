import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/style/boxsize.dart';
import 'package:ited_study/core/config/routes/route.dart';
import '../../../../core/config/style/text_style.dart.dart';
import '../providers/create_school_provider.dart';

class CountryAndSchoolScreen extends ConsumerStatefulWidget {
  const CountryAndSchoolScreen({super.key});

  @override
  ConsumerState<CountryAndSchoolScreen> createState() =>
      CountryAndSchoolScreenState();
}

class CountryAndSchoolScreenState
    extends ConsumerState<CountryAndSchoolScreen> {
  String? selectedCountry;
  String? selectedSchool;
  List<String> countries = [];
  List<String> schools = [];

  void fetchCountry() {
    var box = Hive.box('countries');

    setState(() {
      countries = List<String>.from(box.get('countryList', defaultValue: []));
    });
  }

  void fetchSchools() {
    if (selectedCountry == null) [];
    var box = Hive.box('countries');

    setState(() {
      schools = box.get(selectedCountry, defaultValue: []) as List<String>;
    });
  }

  @override
  void initState() {
    fetchCountry();
    super.initState();
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
              items: countries.map((String countryName) {
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
                fetchSchools();
              },
            ),
            CustomSizeBox.largeBox,
            Text(
              "University",
              style: CustomTextStyles.nameTitle,
            ),
            CustomSizeBox.smallBox,
            DropdownButtonFormField(
              dropdownColor: Colors.white,
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
              items: schools.map((String schoolName) {
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
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
            ),
          ],
        ),
      ),
    );
  }
}
