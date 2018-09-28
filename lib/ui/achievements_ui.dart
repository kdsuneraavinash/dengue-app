import 'package:dengue_app/logic/achievements.dart';
import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  final List<Achievement> achievements = Achievement.achievements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Achievements"),
      ),
      body: ListView.builder(
        itemBuilder: (_, i) => achievements[i].isDivider
            ? Divider()
            : ListTile(
                title: Text(achievements[i].title),
                subtitle: Text(achievements[i].description),
                leading: CircleAvatar(
                  child: Icon(
                    achievements[i].icon,
                    color: Colors.white,
                  ),
                  backgroundColor: (achievements[i].timesTaken == 0)
                      ? Colors.blueGrey
                      : achievements[i].color[800],
                ),
              ),
        itemCount: achievements.length,
      ),
    );
  }
}
