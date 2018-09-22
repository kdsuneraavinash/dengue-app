import 'package:dengue_app/logic/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildEventFlaggedItemButton(context);
  }

  /// Flagged Item
  Widget _buildEventFlaggedItemButton(BuildContext context) {
    return ExpansionTile(
      key: Key(task.taskTitle),
      title: Text(task.taskTitle),
      leading: CircleAvatar(
        child: Text("${task.allocatedPoints}"),
      ),
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            task.taskSteps,
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Text(
            task.remainingChancesString,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildActionButtonButton(
                icon: Icons.label_important,
                label: "Complete",
                onPressed: () => _handleViewPressed(context),
                context: context),
          ],
        ),
      ],
    );
  }

  /// Buttons in Flagged Card
  Widget _buildActionButtonButton(
      {IconData icon,
      String label,
      VoidCallback onPressed,
      BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: OutlineButton.icon(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  /// Will show EventImageView
  void _handleViewPressed(BuildContext context) {}

  TaskCard(this.task);

  final Task task;
}
