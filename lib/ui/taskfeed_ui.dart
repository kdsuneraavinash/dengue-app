import 'package:dengue_app/logic/task.dart';
import 'package:dengue_app/ui/taskcard_ui.dart';
import 'package:flutter/material.dart';

class TaskFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      TaskCard(
        Task(
          taskTitle: "Share Posts",
          allocatedPoints: 25,
          remainingChances: 30,
          taskImage:
              "https://us.123rf.com/450wm/kali13/kali131703/kali13170300064/74185019-cell-phone-with-messages-sms-concept-with-letters-and-paper-planes.jpg?ver=6",
        ),
      ),
      TaskCard(
        Task(
          taskTitle: "Read Articles",
          allocatedPoints: 30,
          remainingChances: 4,
          taskImage:
              "http://lankasee.com/wp-content/uploads/2017/11/476a9331fc6ff72dab916e903d434189_XL.jpg",
        ),
      ),
      TaskCard(
        Task(
          taskTitle: "Share Artcles and Spread Awareness",
          allocatedPoints: 150,
          remainingChances: 4,
          taskImage: "https://i.ytimg.com/vi/hhd7RR4b0Zc/maxresdefault.jpg",
        ),
      ),
      TaskCard(
        Task(
            taskTitle: "Create a vlog of Cleaning your garden",
            allocatedPoints: 1000,
            remainingChances: 1,
            taskImage:
                "http://static.dailymirror.lk/media/images/image_1467830611-f4b5923e3a.jpg"),
      ),
      SizedBox(
        height: 75.0,
        child: Center(
          child: Text("No more tasks to show."),
        ),
      )
    ]);
  }
}
