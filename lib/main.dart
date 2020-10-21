import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
    GetMaterialApp(
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
        primaryColor: Colors.grey.shade100,
        fontFamily: 'Mapo금빛나루',
        accentColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade100,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey.shade800),
          textTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.grey.shade600, fontFamily: 'Mapo금빛나루'),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade800,
        ),
      ),
    ),
  );
}
