import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  late SharedPreferences _pref;

  SharedPrefHelper() {
    init();
  }

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }
}
