import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:story_app/models/post.dart';

class HomeController extends GetxController {
  final RxList<Post> files = <Post>[].obs;

  @override
  onInit() {
    initialize();
    super.onInit();
  }

  Future initialize() {
    return getApplicationDocumentsDirectory().then((Directory directory) {
      String path = '${directory.path}/notes';
      if (!Directory(path).existsSync()) {
        Directory(path).createSync();
      }
      return Directory(path).listSync();
    }).then((List<FileSystemEntity> files) {
      return Future.wait(files.map((file) async {
        fm.FrontMatterDocument doc = await fm.parseFile(file.path);
        return Post(path: file.path, doc: doc);
      }).toList());
    }).then((List<Post> list) {
      if (list.isEmpty) {
        return list;
      }

      list.sort((Post a, Post b) {
        DateTime dateA = DateTime.parse(a.doc.data['created_at']);
        DateTime dateB = DateTime.parse(b.doc.data['created_at']);
        return dateB.millisecondsSinceEpoch
            .compareTo(dateA.millisecondsSinceEpoch);
      });
      return list;
    }).then((List<Post> newDocs) {
      files.value = newDocs;
    });
  }
}
