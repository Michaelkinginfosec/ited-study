import 'package:hive_flutter/hive_flutter.dart';

import '../../models/users.dart';

class UserLocalDatasource {
  Future<Users> getStoredUser() {
    final box = Hive.box("usersBox");
    final user = box.get("users", defaultValue: null);
    return user;
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

  Future<List<String>> getStoredSchool(String? country) async {
    if (country == null) return [];
    var box = await Hive.openBox('countries');
    return List<String>.from(box.get(country, defaultValue: []));
  }
}
