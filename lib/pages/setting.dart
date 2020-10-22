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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('더보기'),
      ),
      body: SettingsList(
        backgroundColor: Colors.grey.shade50,
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
                onTap: () {
                  Get.defaultDialog(
                    title: '함께쓰기 안내',
                    middleText:
                        '함께쓰기는 이야기를 다른 사람들과\n나눌 수 있는 공간이에요.\n열심히 만들고 있어요',
                    confirmTextColor: Colors.black,
                    textConfirm: '닫기',
                    onConfirm: () {
                      Get.back();
                    },
                  );
                  // 이미 로그인된 상태면 바로 들어감
                  // 아니면 로그인 안내함
                  // Get.defaultDialog(
                  //   title: '로그인 안내',
                  //   middleText: '함께쓰기는 로그인을 하지만,\n다른 사용자에게 개인정보를 보여주지 않아요',
                  //   textCancel: '닫기',
                  //   textConfirm: '로그인',
                  //   cancelTextColor: Colors.grey.shade700,
                  //   confirmTextColor: Colors.black,
                  //   onConfirm: () {
                  //     Get.back();
                  //     Get.to(CommunityPage());
                  //   },
                  // );
                },
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
