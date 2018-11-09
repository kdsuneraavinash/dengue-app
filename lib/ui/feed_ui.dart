import 'dart:async';

import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:dengue_app/custom_widgets/loading_screen.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/providers/feed_provider.dart';
import 'package:dengue_app/ui/post/ui_image.dart';
import 'package:dengue_app/ui/post/ui_text.dart';
import 'package:dengue_app/ui/post/ui_video.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeedPageBLoCProvider(child: FeedPageContent());
  }
}

class FeedPageContent extends StatefulWidget {
  @override
  FeedPageContentState createState() {
    return new FeedPageContentState();
  }
}

class FeedPageContentState extends State<FeedPageContent>
    with SingleTickerProviderStateMixin {
  FeedBLoC feedBLoC;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    newPostAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    feedBLoC.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    feedBLoC = FeedPageBLoCProvider.of(context);
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
      builder: (_, refreshAvailableSnapshot) => RefreshIndicator(
            onRefresh: () =>
                _handleRefreshPage(refreshAvailableSnapshot.data ?? false),
            child: Stack(
              children: <Widget>[
                StreamBuilder<List<ProcessedPost>>(
                  stream: feedBLoC.postsFeed,
                  builder: (_, postsFeedSnapshot) => postsFeedSnapshot.hasData
                      ? ListView.builder(
                          itemBuilder: (_, i) {
                            Key key = Key(postsFeedSnapshot
                                    .data[i].post.datePosted
                                    .toIso8601String() +
                                postsFeedSnapshot.data[i].post.userName);
                            switch (postsFeedSnapshot.data[i].post.type) {
                              case PostType.Image:
                                return ImagePost(
                                    key: key,
                                    processedPost: postsFeedSnapshot.data[i]);
                              case PostType.Text:
                                return TextPost(
                                    key: key,
                                    processedPost: postsFeedSnapshot.data[i]);
                              case PostType.WeeklyPost:
                                return VideoPost(
                                    key: key,
                                    processedPost: postsFeedSnapshot.data[i]);
                            }
                          },
                          itemCount: postsFeedSnapshot.data.length,
                        )
                      : Center(
                          child: AnimatedLoadingScreen(AnimationFile.GlowLoading),
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

  AnimationController controller;
  Animation<double> newPostAnimation;
}
