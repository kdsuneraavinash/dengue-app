import 'dart:async';

import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:dengue_app/providers/feed_provider.dart';
import 'package:dengue_app/ui/postcard.dart';
import 'package:flutter/material.dart';

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
      if (available ?? false) {
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
                          itemBuilder: (_, i) =>
                              PostCard(processedPost: snapshot.data[i]),
                          itemCount: snapshot.data.length,
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ScaleTransition(
                    scale: newPostAnimation,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.arrow_downward),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Pull to Refresh",
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    if (refreshAvailable) {
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
