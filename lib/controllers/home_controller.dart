import 'dart:io';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<FileSystemEntity> files = <FileSystemEntity>[].obs;

  loadFiles(String path) {
    files.value = Directory(path).listSync();
  }

  List<FileSystemEntity> get fileList {
    return files.value;
  }
}
