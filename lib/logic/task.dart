import 'package:dengue_app/logic/stats.dart';

class Task {
  String _taskTitle = "[Task Title]";
  int _allocatedPoints = 0;
  int _remainingChances = 0;
  String _taskImage;
  StatisticAction _action;

  Task({taskTitle, allocatedPoints, remainingChances, taskImage, action}) {
    _taskTitle = taskTitle;
    _allocatedPoints = allocatedPoints;
    _remainingChances = remainingChances;
    _taskImage = taskImage;
    _action = action;
  }

  String get taskImage => _taskImage;

  int get remainingChances => _remainingChances;

  String get remainingChancesString {
    if (_remainingChances == 0) {
      return "No remaining Chances";
    } else if (_remainingChances == 1) {
      return "Remaining 1 chance";
    } else {
      return "Remaining $_remainingChances chances";
    }
  }

  int get allocatedPoints => _allocatedPoints;

  String get taskTitle => _taskTitle;

  StatisticAction get action => _action;
}
