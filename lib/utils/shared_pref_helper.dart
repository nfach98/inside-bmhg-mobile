import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPrefHelper {
  final SharedPreferences _pref;

  SharedPrefHelper(this._pref);

  // Example helper methods
  String? getString(String key) => _pref.getString(key);
  Future<bool> setString(String key, String value) => _pref.setString(key, value);
  Future<bool> remove(String key) => _pref.remove(key);
}
