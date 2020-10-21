import 'dart:io';

import 'package:animations/animations.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/models/post.dart';
import 'package:story_app/pages/compose.dart';
import 'package:story_app/pages/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
    GetMaterialApp(
      home: StroyApp(),
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

class StroyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text("이야기"),
            actions: [
              FlatButton(
                child: Text('더보기'),
                onPressed: () {
                  Get.to(SettingPage());
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              '남기기',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.to(ComposePage()).then((value) {
                controller.initialize();
              });
            },
          ),
          body: Obx(
            () => ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Post item = controller.files[index];
                DateTime datetime =
                    DateTime.parse(item.doc.data['datetime']).toLocal();
                String month = DateFormat.MMM('ko').format(datetime);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: OpenContainer(
                    key: UniqueKey(),
                    onClosed: (value) {
                      controller.initialize();
                    },
                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: 350.milliseconds,
                    openColor: Colors.grey.shade100,
                    openElevation: 0,
                    tappable: true,
                    closedElevation: 0,
                    closedColor: Colors.white70,
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Material(
                        child: InkWell(
                          onTap: action,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${datetime.day}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      month,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      DateFormat.Hm('ko').format(datetime),
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  item.doc.data['title'] as String == ''
                                      ? '제목없음'
                                      : item.doc.data['title'],
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.doc.data['excerpt'],
                                  maxLines: 3,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      String date =
                          DateFormat.yMMMMEEEEd('ko').format(datetime);
                      String time = DateFormat.Hm('ko').format(datetime);
                      return Scaffold(
                        backgroundColor: Colors.grey.shade100,
                        appBar: AppBar(
                          title: Text('자세히 보기'),
                          actions: [
                            PopupMenuButton<int>(
                              onSelected: (selected) {
                                switch (selected) {
                                  case 0:
                                    String content =
                                        "${item.doc.data['title']}\n${item.doc.content}";
                                    FlutterClipboard.copy(content)
                                        .then((value) {
                                      Get.snackbar('클립보드에 복사',
                                          '잘 복사되었습니다. 다른 곳에서 붙여넣으세요.');
                                    });

                                    break;
                                  case 10:
                                    Get.to(ComposePage(item: item))
                                        .then((result) {
                                      Get.back();
                                    });
                                    break;
                                  case 20:
                                    Get.defaultDialog(
                                      title: '이 이야기를 지울까요?',
                                      barrierDismissible: true,
                                      radius: 8,
                                      middleText: '',
                                      textConfirm: '네',
                                      textCancel: '아니요',
                                      cancelTextColor: Colors.black,
                                      confirmTextColor: Colors.red,
                                      buttonColor: Colors.white,
                                      onConfirm: () {
                                        File(item.path).deleteSync();
                                        Get.back();
                                        Get.back();
                                      },
                                    ).then((value) {
                                      return null;
                                    });
                                    break;
                                  default:
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text("복사"),
                                ),
                                PopupMenuItem(
                                  value: 10,
                                  child: Text("고치기"),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 20,
                                  child: Text("지우기"),
                                ),
                              ],
                            )
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // FrontMatter
                                // Title
                                if (item.doc.data['title'] != '')
                                  Text(
                                    item.doc.data['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                  ),
                                // DateTime
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    '$date $time',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                // Content
                                Text(
                                  item.doc.content,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: controller.files.length,
            ),
          ),
        );
      },
    );
  }
}
