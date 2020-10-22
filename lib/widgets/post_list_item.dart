import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/models/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    Key key,
    @required this.item,
    @required this.action,
  }) : super(key: key);

  final Post item;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.parse(item.doc.data['created_at']).toLocal();
    String month = DateFormat.MMM('ko').format(datetime);

    return Material(
      child: InkWell(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    DateFormat.Hm('ko').format(datetime),
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                item.doc.data['title'] as String == ''
                    ? '제목없음'
                    : item.doc.data['title'],
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                item.doc.data['excerpt'],
                maxLines: 3,
                overflow: TextOverflow.fade,
                softWrap: true,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
