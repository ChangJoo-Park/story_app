import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:story_app/models/post.dart';
import 'package:story_app/pages/compose.dart';

class PostView extends StatelessWidget {
  const PostView({Key key, @required this.item}) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.parse(item.doc.data['created_at']).toLocal();
    String date = DateFormat.yMMMMEEEEd('ko').format(datetime);
    String time = DateFormat.Hm('ko').format(datetime);

    return Scaffold(
      appBar: AppBar(
        title: Text('자세히 보기'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (selected) {
              switch (selected) {
                case 0:
                  String content =
                      "${item.doc.data['title']}\n${item.doc.content}";
                  FlutterClipboard.copy(content).then((value) {
                    Get.snackbar('클립보드에 복사', '잘 복사되었습니다. 다른 곳에서 붙여넣으세요.');
                  });

                  break;
                case 10:
                  Get.to(ComposePage(item: item)).then((result) {
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
                  style: Theme.of(context).textTheme.headline5.copyWith(
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
  }
}
