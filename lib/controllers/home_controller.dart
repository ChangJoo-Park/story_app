import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_matter/front_matter.dart' as fm;

class HomeController extends GetxController {
  final RxList<fm.FrontMatterDocument> files = <fm.FrontMatterDocument>[].obs;

  @override
  onInit() {
    initialize();
    super.onInit();
  }

  Future<List<fm.FrontMatterDocument>> initialize() {
    return getApplicationDocumentsDirectory().then((Directory directory) {
      String path = '${directory.path}/notes';
      return Directory(path).listSync();
    }).then((List<FileSystemEntity> files) {
      return Future.wait(files.map((file) => fm.parseFile(file.path)).toList());
    }).then((List<fm.FrontMatterDocument> list) {
      list.sort((fm.FrontMatterDocument a, fm.FrontMatterDocument b) {
        DateTime dateA = DateTime.parse(a.data['datetime']);
        DateTime dateB = DateTime.parse(b.data['datetime']);
        return dateB.millisecondsSinceEpoch
            .compareTo(dateA.millisecondsSinceEpoch);
      });
      return list;
    }).then((List<fm.FrontMatterDocument> newDocs) {
      files.value = newDocs;
    });
  }
}
