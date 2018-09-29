import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildEventFlaggedItemButton(context);
  }

  /// Flagged Item
  Widget _buildEventFlaggedItemButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black), color: Colors.blueGrey[100]),
      key: Key(task.taskTitle),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: DefParameterNetworkImage(
              imageUrl: task.taskImage,
              isCover: true,
            ),
          ),
          ListTile(
            title: Text(task.taskTitle),
            leading: CircleAvatar(
              child: Text(
                "${task.allocatedPoints}",
              ),
            ),
            trailing: Text(
              "(${task.remainingChances})",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20.0,
              ),
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
