import 'dart:async';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/pages/compose.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
    GetMaterialApp(
      home: StroyApp(),
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
        return StreamBuilder(
          stream: documentDirectoryStream,
          builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            String path = '${snapshot.data.path}/notes';
            if (!Directory(path).existsSync()) {
              Directory(path).createSync();
            }

            controller.loadFiles(path);

            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: Text("이야기"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: Text(
                  '남기기',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.to(ComposePage()).then((value) {
                    controller.loadFiles(path);
                  });
                },
              ),
              body: Obx(
                () => ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future: fm.parseFile(controller.fileList[index].path),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        fm.FrontMatterDocument doc = snapshot.data;
                        DateTime datetime =
                            DateTime.parse(doc.data['datetime']).toLocal();
                        String month = DateFormat.MMM('ko').format(datetime);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: OpenContainer(
                            transitionType: ContainerTransitionType.fade,
                            transitionDuration: 350.milliseconds,
                            openElevation: 0,
                            key: UniqueKey(),
                            tappable: true,
                            closedBuilder:
                                (BuildContext context, void Function() action) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                          '${datetime.hour}:${datetime.minute}',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      doc.data['title'],
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      doc.data['excerpt'],
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              );
                            },
                            openBuilder: (BuildContext context,
                                void Function({Object returnValue}) action) {
                              String date =
                                  DateFormat.yMMMMEEEEd('ko').format(datetime);
                              String time =
                                  DateFormat.Hm('ko').format(datetime);
                              return Scaffold(
                                backgroundColor: Colors.grey.shade100,
                                appBar: AppBar(
                                  title: Text('자세히 보기'),
                                  actions: [
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) {
                                        return;
                                      },
                                    ),
                                  ],
                                ),
                                persistentFooterButtons: [
                                  IconButton(
                                    icon: Icon(Icons.star_border),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                                body: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // FrontMatter
                                        // DateTime
                                        Container(
                                          alignment: Alignment.centerRight,
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          child: Text('$date $time',
                                              textAlign: TextAlign.right),
                                        ),
                                        // Title
                                        Text(
                                          doc.data['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        // Content
                                        SizedBox(height: 16),
                                        Text(
                                          doc.content,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
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
                    );
                  },
                  itemCount: controller.fileList.length,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Stream<Directory> get documentDirectoryStream {
    return getApplicationDocumentsDirectory().asStream();
  }
}
