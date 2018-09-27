import 'package:dengue_app/logic/task.dart';
import 'package:dengue_app/ui/taskcard_ui.dart';
import 'package:flutter/material.dart';

class TaskFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      TaskCard(
        Task(
            taskTitle: "Clean your garden and post a video",
            allocatedPoints: 1000,
            remainingChances: 1,
            taskSteps:
                "Perhaps far exposed age effects. Now distrusts you her delivered applauded affection out sincerity. As tolerably recommend shameless unfeeling he objection consisted. She although cheerful perceive screened throwing met not eat distance. Viewing hastily or written dearest elderly up weather it as. So direction so sweetness or extremity at daughters. Provided put unpacked now but bringing."),
      ),
      TaskCard(
        Task(
            taskTitle: "Share Posts",
            allocatedPoints: 25,
            remainingChances: 30,
            taskSteps:
                "In no impression assistance contrasted. Manners she wishing justice hastily new anxious. At discovery discourse departure objection we. Few extensive add delighted tolerably sincerity her. Law ought him least enjoy decay one quick court. Expect warmly its tended garden him esteem had remove off. Effects dearest staying now sixteen nor improve. "),
      ),
      TaskCard(
        Task(
            taskTitle: "Like Posts",
            allocatedPoints: 5,
            remainingChances: 50,
            taskSteps:
                "Prevailed sincerity behaviour to so do principle mr. As departure at no propriety zealously my. On dear rent if girl view. First on smart there he sense. Earnestly enjoyment her you resources. Brother chamber ten old against. Mr be cottage so related minuter is. Delicate say and blessing ladyship exertion few margaret. Delight herself welcome against smiling its for. Suspected discovery by he affection household of principle perfectly he. "),
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
