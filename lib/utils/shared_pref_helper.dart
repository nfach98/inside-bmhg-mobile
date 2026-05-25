import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/config/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPrefHelper {
  final SharedPreferences _pref;

  SharedPrefHelper(this._pref);

  String? getString(String key) => _pref.getString(key);
  Future<bool> setString(String key, String value) => _pref.setString(key, value);
  Future<bool> remove(String key) => _pref.remove(key);

  String? getToken() => _pref.getString(PrefKeys.authToken);

  Future<void> saveToken(String token) =>
      setString(PrefKeys.authToken, token);

  Future<void> clearToken() => remove(PrefKeys.authToken);
}
