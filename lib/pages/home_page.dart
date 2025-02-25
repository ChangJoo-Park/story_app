import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_app/controllers/home_controller.dart';
import 'package:story_app/models/post.dart';
import 'package:story_app/pages/compose.dart';
import 'package:story_app/pages/post.dart';
import 'package:story_app/pages/setting.dart';
import 'package:story_app/widgets/post_list_item.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이야기"),
        actions: [
          FlatButton(
            child: Text('더보기'),
            onPressed: () {
              Get.to(SettingPage());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          '남기기',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Get.to(ComposePage()).then((value) => controller.initialize());
        },
      ),
      body: Obx(
        () => controller.files.length == 0
            ? Center(child: Text('오늘 어떤 일이 있었나요?'))
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) => StoryItem(
                  initialize: controller.initialize,
                  item: controller.files[index],
                ),
                itemCount: controller.files.length,
              ),
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  const StoryItem({
    Key key,
    @required this.initialize,
    @required this.item,
  }) : super(key: key);

  final Function initialize;
  final Post item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OpenContainer(
        key: UniqueKey(),
        onClosed: (value) {
          initialize();
        },
        transitionType: ContainerTransitionType.fade,
        transitionDuration: 350.milliseconds,
        openColor: Colors.grey.shade100,
        openElevation: 0,
        tappable: true,
        closedElevation: 0,
        closedColor: Colors.white70,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        closedBuilder: (BuildContext context, void Function() action) {
          return PostListItem(item: item, action: action);
        },
        openBuilder: (BuildContext context,
                void Function({Object returnValue}) action) =>
            PostView(item: item),
      ),
    );
  }
}
