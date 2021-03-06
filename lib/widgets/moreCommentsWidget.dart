import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:openReddit/widgets/commentListWidget.dart';

class MoreCommentsWidget extends StatefulWidget {
  final MoreComments moreComments;
  final int depth;

  MoreCommentsWidget({Key key, this.moreComments, this.depth = 0}) : super(key: key);

  _MoreCommentsWidgetState createState() => _MoreCommentsWidgetState();
}

class _MoreCommentsWidgetState extends State<MoreCommentsWidget> {
  bool _loaded = false;
  bool _loading = false;
  List<dynamic> _loadedComments = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    if(_loaded) {
      return CommentListWidget(comments: this._loadedComments, noScroll: true);
    } else
    if(_loading) {
      return Padding(
        padding: EdgeInsets.only(left: (widget.depth * 5).toDouble()),
        child: LinearProgressIndicator(),
      );
    } else 
    return Padding(
      padding: EdgeInsets.only(left: (widget.depth * 5).toDouble()),
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          setState(() {
           this._loading = true; 
          });
          MoreComments moreComments = widget.moreComments;
          List<dynamic> loadedCommentsDyn = await moreComments.comments(update: true);
          setState(() {
            this._loading = false;
            this._loaded = true;
            this._loadedComments = loadedCommentsDyn;
          });
        },
        child: Text('Load more comments(' + widget.moreComments.count.toString() + ')'),
      ),
    );
  }

}
