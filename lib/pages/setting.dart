import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';

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
                title: '함께쓰기',
                subtitle: '다른 사용자들과 이야기를 나누세요.',
                leading: Icon(Icons.connect_without_contact),
                titleTextStyle: settingTitleStyle,
              ),
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
              ),
              SettingsTile(
                title: '이야기 앱 공유하기',
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
