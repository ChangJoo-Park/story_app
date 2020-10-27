import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/pages/home_page.dart';
import 'package:story_app/services/setting_service.dart';
import 'package:story_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await initServices();

  /// AWAIT SERVICES INITIALIZATION.

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('ko', 'KR'),
      fallbackLocale: Locale('ko', 'KR'),
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
      theme: getTheme().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{},
        ),
      ),
    ),
  );
}

initServices() async {
  print('starting services ...');
  await Get.putAsync(() => SettingService().init());
  print('All services started...');
}
