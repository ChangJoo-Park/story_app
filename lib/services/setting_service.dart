import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService extends GetxService {
  SharedPreferences _prefs;

  Future init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('initialized') || !_prefs.getBool('initialized')) {
      await Future.wait([
        _prefs.setBool('initialized', true),
        _prefs.setString('font', 'Mapo금빛나루'),
        _prefs.setString('theme', 'default'),
        _prefs.setString('locale', 'ko'),
      ]);
    }

    print('$runtimeType delays 1 sec');
    await 1.delay();
    print('$runtimeType ready!');
  }
}
