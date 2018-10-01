import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/task.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            DefParameterNetworkImage(
              imageUrl: task.taskImage,
              isCover: true,
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                color: Colors.black,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: null,
                      icon: Icon(FontAwesomeIcons.coins, color: Colors.amber),
                      label: Text(
                        "+${task.allocatedPoints}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    _buildActionButtonButton(
                      icon: FontAwesomeIcons.play,
                      context: context,
                      label: "Complete",
                      onPressed: () => Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Task not implemnted yet."))),
                    )
                  ],
                ),
              ),
            ),
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: FlatButton.icon(
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
