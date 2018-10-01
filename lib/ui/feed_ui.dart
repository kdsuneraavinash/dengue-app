import 'dart:async';

import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/providers/feed_provider.dart';
import 'package:dengue_app/ui/post/ui_image.dart';
import 'package:dengue_app/ui/post/ui_text.dart';
import 'package:dengue_app/ui/post/ui_video.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() {
    return new FeedPageState();
  }
}

class FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  FeedBLoC feedBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    feedBLoC = FeedBLoCProvider.of(context);
    feedBLoC.refreshAvailable.listen((available) {
      if (mounted && available ?? false) {
        setState(() {
          controller.forward();
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: feedBLoC.refreshAvailable,
      builder: (_, refreshSnapshot) => RefreshIndicator(
            onRefresh: () => _handleRefreshPage(refreshSnapshot.data ?? false),
            child: Stack(
              children: <Widget>[
                StreamBuilder<List<ProcessedPost>>(
                  stream: feedBLoC.postsFeed,
                  builder: (_, snapshot) => snapshot.hasData
                      ? ListView.builder(
                          itemBuilder: (_, i) {
                            Key key = Key(snapshot.data[i].post.datePosted
                                    .toIso8601String() +
                                snapshot.data[i].post.userName);
                            switch (snapshot.data[i].post.type) {
                              case PostType.Image:
                                return ImagePost(
                                    key: key, processedPost: snapshot.data[i]);
                              case PostType.Text:
                                return TextPost(
                                    key: key, processedPost: snapshot.data[i]);
                              case PostType.WeeklyPost:
                                return VideoPost(
                                    key: key, processedPost: snapshot.data[i]);
                            }
                          },
                          itemCount: snapshot.data.length,
                        )
                      : Center(
                          child: HeartbeatProgressIndicator(
                            child: Icon(
                              FontAwesomeIcons.newspaper,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
                FadeTransition(
                  opacity: newPostAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0.0, 1.0),
                                color: Color(0x88000000),
                              )
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              "Pull to Refresh Updates",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
    );
  }

  Future<void> _handleRefreshPage(bool refreshAvailable) {
    controller.reverse();
    Completer waitForFinish = Completer();
    if (refreshAvailable && mounted) {
      feedBLoC.refreshFinished.listen((_) {
        try {
          waitForFinish.complete();
        } catch (StateError) {
          print("Future already completed");
        }
      });
      feedBLoC.refreshCommandIssued.add(null);
    } else {
      Future.delayed(Duration(seconds: 1))
          .then((_) => waitForFinish.complete());
    }
    return waitForFinish.future;
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    newPostAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  AnimationController controller;
  Animation<double> newPostAnimation;
}
