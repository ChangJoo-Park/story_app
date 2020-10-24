import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  if (!_prefs.containsKey('initialized') || !_prefs.getBool('initialized')) {
    await Future.wait([
      _prefs.setBool('initialized', true),
      _prefs.setString('font', 'Mapo금빛나루'),
      _prefs.setString('locale', 'ko'),
    ]);
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<HomeController>(() => HomeController());
          }),
        ),
      ],
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      theme: ThemeData(
        primaryColor: Colors.grey.shade50,
        fontFamily: _prefs.getString('font'),
        accentColor: Colors.grey.shade50,
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade50,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey.shade800),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.grey.shade600,
              fontFamily: _prefs.getString('font'),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade800,
        ),
      ),
    ),
  );
}
