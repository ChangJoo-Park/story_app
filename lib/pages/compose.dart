import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ComposePage extends StatefulWidget {
  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date;
  TimeOfDay timeOfDay;

  @override
  void initState() {
    setState(() {
      title = DateFormat.yMMMMEEEEd('ko').format(DateTime.now()) +
          ' ' +
          DateFormat.Hm('ko').format(DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.grey.shade800),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '새 글쓰기',
          style: TextStyle(color: Colors.grey.shade800),
        ),
      ),
      persistentFooterButtons: [
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
              lastDate: DateTime.now().add(Duration(days: 365 * 10)),
              initialDate: DateTime.now(),
            ).then((newDate) {
              if (newDate == null) {
                return;
              }
              setState(() {
                date = newDate;
              });
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((newTime) {
              if (newTime == null) {
                return;
              }
              setState(() {
                timeOfDay = newTime;
              });
            }).catchError((e) {
              print(e);
            });
          },
        ),
        // IconButton(
        //   icon: Icon(Icons.photo),
        //   onPressed: () {
        //     Get.back();
        //   },
        // ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            // Keyboard Hide
            FocusScope.of(context).unfocus();
            // 여기서 조립
            _formKey.currentState.save();
            final directory = await getApplicationDocumentsDirectory();
            final filename = DateTime.now().toUtc();
            final path = '${directory.path}/notes/$filename.txt';
            File(path).createSync();
            File(path).writeAsStringSync('''---
title: "$title"
excerpt: "$excerpt"
datetime: "${DateTime.now().toUtc()}"
images: ""
---
$description''');
            Get.back();
          },
        ),
      ],
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
                  decoration: InputDecoration(
                    focusColor: Colors.grey,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0)),
                    border: const UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0)),
                    hintText: '제목을 적어주세요',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onSaved: (value) => setState(() => title = value),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "이야기를 적어주세요",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 99999,
                  autofocus: true,
                  onSaved: (value) => setState(() => description = value),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String get excerpt {
    String plainText = description.split('\n').join();
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
