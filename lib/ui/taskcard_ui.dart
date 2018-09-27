import 'package:dengue_app/logic/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildEventFlaggedItemButton(context);
  }

  /// Flagged Item
  Widget _buildEventFlaggedItemButton(BuildContext context) {
    return Card(
      key: Key(task.taskTitle),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(task.taskTitle),
            leading: CircleAvatar(
              child: Text("${task.allocatedPoints}"),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(task.taskSteps, textAlign: TextAlign.justify),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.timer,
                            color: Theme.of(context).accentColor),
                        SizedBox(width: 10.0),
                        Text(
                          "${task.remainingChancesString}",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildActionButtonButton(
                    icon: Icons.label_important,
                    label: "Complete",
                    onPressed: () => _handleViewPressed(context),
                    context: context),
              ],
            ),
          ),
        ],
      ),
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
