import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static const keyName = 'name';
  static const keyImage = 'image';

  Future<bool> setSettings(String name, String image) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(keyName, name),
        prefs.setString(keyImage, image),
      ]);
      return true;
    } on Exception catch (e) {
      log('Error ${e.toString()}');
      return false;
    }
  }

  Future<Map<String, String>?> getSettings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(keyName) ?? '';
      final image = prefs.getString(keyImage) ?? '';
      return {
        keyName: name,
        keyImage: image,
      };
    } on Exception catch (e) {
      log('Error ${e.toString()}');
      return null;
    }
  }
}
