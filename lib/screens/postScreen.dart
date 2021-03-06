import 'dart:async';

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:openReddit/widgets/commentListWidget.dart';
import 'package:openReddit/widgets/postWidget.dart';

class PostScreen extends StatefulWidget {
  final Submission submission;

  PostScreen({Key key, this.submission}) : super(key: key);

  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _comments;

  @override
  void initState() {
    this._getComments();
    super.initState();
  }

  Future<void> _getComments() async {
    Completer c = new Completer();
    widget.submission.refreshComments().then((val) {
      if(this.mounted)
        setState(() {
          this._comments = widget.submission.comments.comments;
        });
      c.complete();
    });
    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.submission.title),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return this._getComments();
        },
        child: Column(
          children: <Widget>[
            this._comments != null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CommentListWidget(
                      comments: this._comments,
                      highlightUserName: widget.submission.author,
                      leading: Column(
                        children: <Widget>[
                          PostWidget(
                            submission: widget.submission,
                            preview: false,
                            onReply: (Comment replyComment) async {
                              setState(() {
                                this._comments.add(replyComment);
                              });
                              // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) { return PostScreen(submission: widget.submission); }));
                              // this._getComments();
                            },
                          ),
                          Divider(),
                        ],
                      )
                  ),
                )
              )
              : LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

}
