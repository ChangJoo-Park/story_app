import 'dart:async';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:story_app/pages/compose.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
    GetMaterialApp(
      home: StroyApp(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.grey.shade700),
      ),
    ),
  );
}

class StroyApp extends StatelessWidget {
  @override
  Widget build(context) {
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

        List<FileSystemEntity> files = Directory(path).listSync();

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text("Clicks:"),
            actions: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  Directory(path).deleteSync(recursive: true);
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text('새 글 쓰기'),
            onPressed: () {
              Get.to(ComposePage());
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: fm.parseFile(files[index].path),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  fm.FrontMatterDocument doc = snapshot.data;
                  print(doc.data);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fade,
                      transitionDuration: 500.milliseconds,
                      onClosed: (value) {},
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'OCT',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '11시 10분',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                doc.data['title'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                doc.data['excerpt'],
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      },
                      openBuilder: (BuildContext context,
                          void Function({Object returnValue}) action) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text(doc.data['title']),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // FrontMatter
                                  // DateTime
                                  Text(doc.data['datetime'],
                                      textAlign: TextAlign.right),
                                  // Title
                                  Text(
                                    doc.data['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  // Content
                                  SizedBox(height: 16),
                                  Text(
                                    doc.content,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
            itemCount: files.length,
          ),
        );
      },
    );
  }

  Stream<Directory> get documentDirectoryStream {
    return getApplicationDocumentsDirectory().asStream();
  }
}
