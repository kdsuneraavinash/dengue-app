import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/stats.dart';
import 'package:dengue_app/logic/task.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/ad_ui.dart';
import 'package:dengue_app/ui/taskcard_ui.dart';
import 'package:dengue_app/ui/upload/ui_video.dart';
import 'package:flutter/material.dart';

class TaskFeedPage extends StatefulWidget {
  @override
  TaskFeedPageState createState() {
    return new TaskFeedPageState();
  }
}

class TaskFeedPageState extends State<TaskFeedPage> {
  UserBLoC userBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userBLoC = UserBLoCProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      TaskCard(
        Task(
            taskTitle: "Create a vlog of Cleaning your garden",
            allocatedPoints: 250,
            remainingChances: 1,
            action: StatisticAction.WeeklyPost,
            enabled: true,
            taskImage:
                "http://static.dailymirror.lk/media/images/image_1467830611-f4b5923e3a.jpg",
            function: () {
              TransitionMaker.fadeTransition(
                  destinationPageCall: () => UploadWeekly())
                ..start(context);
            }),
      ),
      TaskCard(
        Task(
            taskTitle: "Watch Ads",
            allocatedPoints: 15,
            remainingChances: 1000,
            action: StatisticAction.WatchedAd,
            enabled: true,
            taskImage:
                "https://growtraffic.com/blog/wp-content/uploads/2015/08/CPM-over-CPC.jpg",
            function: () async {
              TransitionMaker transition = TransitionMaker.fadeTransition(
                  destinationPageCall: () => AdScreen());

              var watched = await transition.startAndWait(context);
              if (watched == true) {
                userBLoC.addStatsSink.add(StatisticAction.WatchedAd);
              }
            }),
      ),
      TaskCard(
        Task(
          taskTitle: "Share Text/Photo/Video Posts",
          allocatedPoints: 5,
          remainingChances: 300,
          action: StatisticAction.SharedPost,
          enabled: true,
          function: () {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Use Button in the bottom-right to post.")));
          },
          taskImage:
              "https://us.123rf.com/450wm/kali13/kali131703/kali13170300064/74185019-cell-phone-with-messages-sms-concept-with-letters-and-paper-planes.jpg?ver=6",
        ),
      ),
      TaskCard(
        Task(
          taskTitle: "Read Articles",
          allocatedPoints: 30,
          remainingChances: 4,
          action: StatisticAction.ReadArticle,
          taskImage:
              "http://lankasee.com/wp-content/uploads/2017/11/476a9331fc6ff72dab916e903d434189_XL.jpg",
        ),
      ),
      TaskCard(
        Task(
          taskTitle: "Share Artcles and Spread Awareness",
          allocatedPoints: 150,
          remainingChances: 4,
          action: StatisticAction.SharedArticle,
          taskImage: "https://i.ytimg.com/vi/hhd7RR4b0Zc/maxresdefault.jpg",
        ),
      ),
      SizedBox(
        height: 75.0,
        child: Center(
          child: Text("More tasks coming soon"),
        ),
      )
    ]);
  }
}
