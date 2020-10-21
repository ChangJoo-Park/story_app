import 'package:front_matter/front_matter.dart';

class Post {
  String path;
  FrontMatterDocument doc;

  Post({
    this.path,
    this.doc,
  });

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(path: json['path'], doc: json['doc']);
  }
}
