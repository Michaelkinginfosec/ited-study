import 'package:hive_flutter/hive_flutter.dart';

import '../../models/users.dart';

class UserLocalDatasource {
  Future<Users> getStoredUser() async {
    final box = Hive.box("usersBox");
    final user = box.get("users", defaultValue: null);
    return user;
  }

  Future<void> storeCountries(List<String> countryList) async {
    var box = Hive.box('countries');
    await box.put('countryList', countryList);
  }

  Future<void> storeSchools(String country, List<String> schoolList) async {
    var box = Hive.box('countries');
    await box.put(country, schoolList);
  }

  Future<List<String>> getStoredCountries() async {
    var box = Hive.box('countries');
    return List<String>.from(
      box.get(
        'countryList',
        defaultValue: [],
      ),
    );
  }

  Future<List<String>> getStoredSchools(String country) async {
    var box = Hive.box('countries');
    return List<String>.from(box.get(country) ?? []);
  }

  // Future<List<String>> getStoredCountries() async {
//     var box = Hive.box('countries');
//     return List<String>.from(box.get('countryList') ?? []);
//   }
}
