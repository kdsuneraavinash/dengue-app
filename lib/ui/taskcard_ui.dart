import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/task.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskCard extends StatefulWidget {
  @override
  TaskCardState createState() {
    return new TaskCardState();
  }

  TaskCard(this.task);

  final Task task;
}

class TaskCardState extends State<TaskCard> {
  UserBLoC userBLoC;
  List<Widget> pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userBLoC = UserBLoCProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventFlaggedItemButton(context);
  }

  /// Flagged Item
  Widget _buildEventFlaggedItemButton(BuildContext context) {
    return ExpansionTile(
      key: Key(widget.task.taskTitle),
      title: Text(
        widget.task.taskTitle,
        style:
            TextStyle(color: widget.task.enabled ? Colors.black : Colors.grey),
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                DefParameterNetworkImage(
                  imageUrl: widget.task.taskImage,
                  isCover: true,
                ),
                Opacity(
                  opacity: widget.task.enabled ? 0.0 : 0.8,
                  child: Container(
                    height: MediaQuery.of(context).size.width / (16 / 9),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "This task is unavailable right now",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
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
                        "+${widget.task.allocatedPoints}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    _buildActionButtonButton(
                      icon: FontAwesomeIcons.play,
                      context: context,
                      label: "Complete",
                      onPressed: widget.task.enabled
                          ? () => _handleViewPressed()
                          : null,
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
  void _handleViewPressed() {
    widget.task.doTask();
//    userBLoC.addStatsSink.add(widget.task.action);
  }
}
