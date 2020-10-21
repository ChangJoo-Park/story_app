import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:story_app/models/post.dart';

class ComposePage extends StatefulWidget {
  final Post item;

  ComposePage({this.item});

  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime datetime;
  DateTime date;
  TimeOfDay timeOfDay;
  bool isEdit = false;
  @override
  void initState() {
    setState(() => isEdit = widget.item != null);
    if (isEdit) {
      setState(() {
        title = widget.item.doc.data['title'];
        description = widget.item.doc.content;
        datetime = DateTime.parse(widget.item.doc.data['datetime']);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _formKey.currentState.save();
        if (title.isEmpty && description.isEmpty) {
          return Future.value(true);
        }
        FocusScope.of(context).unfocus();
        return Get.defaultDialog(
          title: '그만 작성하실래요?',
          barrierDismissible: true,
          radius: 8,
          middleText: '',
          textConfirm: '닫습니다',
          textCancel: '계속합니다',
          cancelTextColor: Colors.black,
          confirmTextColor: Colors.red,
          buttonColor: Colors.white,
          content: Text('닫으시면 작성하던 내용이 사라집니다.'),
          onConfirm: () {
            Get.back();
            Get.back();
          },
        ).then((value) {
          return null;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.grey.shade800),
          backgroundColor: Colors.transparent,
          actions: [
            FlatButton(
              child: Text('저장'),
              onPressed: () async {
                // Keyboard Hide
                FocusScope.of(context).unfocus();
                // 여기서 조립
                _formKey.currentState.save();
                final directory = await getApplicationDocumentsDirectory();
                final filename = DateTime.now().toUtc();
                final path = isEdit
                    ? widget.item.path
                    : '${directory.path}/notes/$filename.txt';
                final String content = '''---
title: "${title.trim()}"
excerpt: "$excerpt"
datetime: "${DateTime.now().toUtc()}"
images: ""
---
$description''';
                if (isEdit) {
                  File(path).writeAsStringSync(content);
                } else {
                  File(path).createSync();
                  File(path).writeAsStringSync(content);
                }
                Get.back(result: content);
              },
            ),
          ],
          elevation: 0,
          title: Text(
            isEdit ? '글 수정하기' : '새 글쓰기',
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Form(
            key: _formKey,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  flex: 0,
                  child: TextFormField(
                    initialValue: title,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    autofocus: !isEdit,
                    decoration: InputDecoration(
                      focusColor: Colors.grey,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: '제목을 적어주세요',
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onSaved: (value) => setState(() => title = value),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    initialValue: description,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "무슨 이야기를 적어볼까요?",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 99999,
                    autofocus: false,
                    enableInteractiveSelection: true,
                    enableSuggestions: true,
                    smartDashesType: SmartDashesType.enabled,
                    smartQuotesType: SmartQuotesType.enabled,
                    onSaved: (value) => setState(() => description = value),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get excerpt {
    String plainText = description.split('\n').join(" ").trim();
    if (plainText.length > 300) {
      plainText = plainText.substring(0, 300);
    }
    return plainText;
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
