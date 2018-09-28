import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Achievement {
  final IconData icon;
  final String title;
  final String description;
  final int points;
  final String id;
  final MaterialColor color;
  final bool isDivider;
  int timesTaken;

  Achievement(
      this.icon, this.title, this.description, this.points, this.id, this.color,
      [this.isDivider = false]) {
    timesTaken = 0;
  }

  factory Achievement.divider() {
    return Achievement(null, null, null, null, null, null, true);
  }

  factory Achievement.dailyVisit(int days, int level, [int timesTaken = 0]) {
    String message =
        (days == 1) ? "Logged in 1 day" : "Logged in $days days in a row";
    int points = days * 5;
    return Achievement(FontAwesomeIcons.walking, "Daily Fighter: ${levels[level]}", message,
        points, "dailyVisit$days", Colors.green)..timesTaken = timesTaken;
  }

  factory Achievement.addPosts(int posts, int level) {
    String message = "Posted $posts posts in the week";
    int points = posts * 5;
    return Achievement(FontAwesomeIcons.newspaper, "Post King: ${levels[level]}", message,
        points, "addPosts$posts", Colors.deepPurple
    );
  }

  static List<String> levels = [
    "Newbie", //0
    "Novice", //1
    "Rookie", //2
    "Beginner", //3
    "Talented", //4
    "Skilled", //5
    "Intermediate", //6
    "Skillful", //7
    "Seasoned", //8
    "Proficient", //9
    "Experienced", //10
    "Advanced", //11
    "Senior", //12
    "Expert" //13
  ];

  static final List<Achievement> achievements = [
    Achievement(
        Icons.verified_user,
        "Verified Account",
        "Create an account using your gmail account",
        250,
        "account",
        Colors.pink)..timesTaken=1,
    Achievement.divider(),
    Achievement.dailyVisit(1, 0, 1),
    Achievement.dailyVisit(2, 2, 1),
    Achievement.dailyVisit(3, 3),
    Achievement.dailyVisit(4, 6),
    Achievement.dailyVisit(5, 8),
    Achievement.dailyVisit(6, 10),
    Achievement.dailyVisit(7, 13),
    Achievement.divider(),
    Achievement.addPosts(1, 0),
    Achievement.addPosts(10, 2),
    Achievement.addPosts(25, 6),
    Achievement.addPosts(50, 10),
    Achievement.addPosts(100, 13),
  ];
}
