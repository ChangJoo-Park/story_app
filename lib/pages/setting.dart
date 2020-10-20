import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatelessWidget {
  final TextStyle settingTitleStyle = TextStyle(color: Colors.grey.shade800);
  final TextStyle settingSectionTitleStyle =
      TextStyle(color: Colors.grey.shade700);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: SettingsList(
        backgroundColor: Colors.grey.shade100,
        shrinkWrap: true,
        sections: [
          SettingsSection(
            titleTextStyle: settingSectionTitleStyle,
            title: '일반 설정',
            tiles: [
              SettingsTile(
                title: '언어',
                subtitle: '한국어',
                leading: Icon(Icons.language),
                titleTextStyle: settingTitleStyle,
              ),
              SettingsTile(
                title: '글꼴',
                subtitle: '마포금빛나루',
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
                title: '커뮤니티 참여',
                subtitle: '개발중입니다.',
                leading: Icon(Icons.chat_bubble),
                titleTextStyle: settingTitleStyle,
              ),
              SettingsTile(
                title: '스토어에 리뷰 남기기',
                leading: Icon(Icons.star_rate),
                titleTextStyle: settingTitleStyle,
              ),
              SettingsTile(
                title: '이야기 후원하기',
                subtitle: '개발중입니다.',
                leading: Icon(Icons.support),
                titleTextStyle: settingTitleStyle,
              ),
              SettingsTile(
                title: '개발자에게 문의하기',
                leading: Icon(Icons.question_answer),
                titleTextStyle: settingTitleStyle,
              ),
              SettingsTile(
                title: '이야기 앱 공유하기',
                leading: Icon(Icons.share),
                titleTextStyle: settingTitleStyle,
              ),
            ],
          ),
          SettingsSection(
            title: '기타',
            titleTextStyle: settingSectionTitleStyle,
            tiles: [
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
      ),
    );
  }
}
