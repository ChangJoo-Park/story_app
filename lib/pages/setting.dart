import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_launcher/store_launcher.dart';

Map<String, String> locale = {
  'ko': '한국어',
  // 'en': 'English',
};

Map<String, String> font = {
  'Mapo금빛나루': '마포 금빛나루',
};

class SettingPage extends StatelessWidget {
  final TextStyle settingTitleStyle = TextStyle(color: Colors.grey.shade800);
  final TextStyle settingSectionTitleStyle =
      TextStyle(color: Colors.grey.shade700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('더보기'),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          SharedPreferences _prefs = snapshot.data;
          return SettingsList(
            backgroundColor: Colors.grey.shade50,
            shrinkWrap: true,
            sections: [
              SettingsSection(
                titleTextStyle: settingSectionTitleStyle,
                title: '일반 설정',
                tiles: [
                  SettingsTile(
                    title: '언어',
                    subtitle: locale[snapshot.data.getString('locale')],
                    leading: Icon(Icons.language),
                    titleTextStyle: settingTitleStyle,
                    onTap: () {
                      showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text('언어를 선택하세요'),
                          children:
                              locale.entries.toList().map((MapEntry mapEntry) {
                            return SimpleDialogOption(
                              child: Text(mapEntry.value),
                              onPressed: () async {
                                await _prefs.setString('locale', mapEntry.key);
                                Get.back();
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: '글꼴',
                    subtitle: font[snapshot.data.getString('font')],
                    leading: Icon(Icons.cloud_queue),
                    titleTextStyle: settingTitleStyle,
                  ),
                ],
              ),
              SettingsSection(
                title: '연락',
                titleTextStyle: settingSectionTitleStyle,
                tiles: [
                  SettingsTile(
                    title: '플레이스토어에 리뷰 남기기',
                    subtitle: '칭찬과 격려를 남겨주세요.',
                    leading: Icon(Icons.star_rate),
                    titleTextStyle: settingTitleStyle,
                    onTap: () async {
                      try {
                        final InAppReview inAppReview = InAppReview.instance;
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      } catch (e) {
                        print('에러');
                      }
                    },
                  ),
                  SettingsTile(
                    title: '이야기 후원하기',
                    subtitle: '개발중입니다.',
                    leading: Icon(Icons.support),
                    titleTextStyle: settingTitleStyle,
                    onTap: () {
                      Get.defaultDialog(
                        title: '후원하기',
                        middleText: '눌러주셔서 고마워요.\n나중에 준비되면 다시 한번 눌러주세요.',
                        confirmTextColor: Colors.black,
                        textConfirm: '닫기',
                        onConfirm: () {
                          Get.back();
                        },
                      );
                    },
                  ),
                  SettingsTile(
                    title: '이야기 앱 알리기',
                    leading: Icon(Icons.share),
                    titleTextStyle: settingTitleStyle,
                    onTap: () {
                      Share.share(
                          '이야기앱을 공유합니다. 오늘부터 조금씩 적어보는건 어떨까요?\nbit.ly/3m7WMc7',
                          subject: 'SHARE_APP');
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: '기타',
                titleTextStyle: settingSectionTitleStyle,
                tiles: [
                  SettingsTile(
                    title: Platform.isAndroid ? '플레이스토어에서 보기' : '앱스토어에서 보기',
                    leading: Icon(Icons.store),
                    titleTextStyle: settingTitleStyle,
                    onTap: () {
                      try {
                        StoreLauncher.openWithStore(
                                'com.changjoopark.story_app')
                            .catchError((e) {
                          print('ERROR> $e');
                        });
                      } on Exception catch (e) {
                        print('$e');
                      }
                    },
                  ),
                  SettingsTile(
                    title: '오픈소스 라이선스',
                    leading: Icon(Icons.collections_bookmark),
                    titleTextStyle: settingTitleStyle,
                    onTap: () {
                      Get.to(LicensePage());
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
