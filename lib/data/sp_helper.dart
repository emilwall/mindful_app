import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static const keyName = 'name';
  static const keyImage = 'image';
  Future setSettings(String name, String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(keyName, name),
      prefs.setString(keyImage, image),
    ]);
  }

  Future<Map<String, String>> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString(keyName) ?? '';
    final String image = prefs.getString(keyImage) ?? '';
    return {
      keyName: name,
      keyImage: image,
    };
  }
}
