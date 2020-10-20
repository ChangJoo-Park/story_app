import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_matter/front_matter.dart' as fm;

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> files = <Map<String, dynamic>>[].obs;

  @override
  onInit() {
    initialize();
    super.onInit();
  }

  Future initialize() {
    return getApplicationDocumentsDirectory().then((Directory directory) {
      String path = '${directory.path}/notes';
      return Directory(path).listSync();
    }).then((List<FileSystemEntity> files) {
      return Future.wait(files.map((file) async {
        fm.FrontMatterDocument doc = await fm.parseFile(file.path);
        Map<String, dynamic> map = {
          'path': file.path,
          'doc': doc,
        };
        return map;
      }).toList());
    }).then((List<Map<String, dynamic>> list) {
      list.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        DateTime dateA = DateTime.parse(a['doc'].data['datetime']);
        DateTime dateB = DateTime.parse(b['doc'].data['datetime']);
        return dateB.millisecondsSinceEpoch
            .compareTo(dateA.millisecondsSinceEpoch);
      });
      return list;
    }).then((List<Map<String, dynamic>> newDocs) {
      files.value = newDocs;
    });
  }
}
