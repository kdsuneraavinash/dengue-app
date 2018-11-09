import 'package:dengue_app/logic/stats.dart';

class Task {
  String _taskTitle = "[Task Title]";
  int _allocatedPoints = 0;
  int _remainingChances = 0;
  String _taskImage;
  StatisticAction _action;
  Function _function;
  bool _enabled;

  Task(
      {taskTitle,
      allocatedPoints,
      remainingChances,
      taskImage,
      action,
      function,
        enabled}) {
    _taskTitle = taskTitle;
    _allocatedPoints = allocatedPoints;
    _remainingChances = remainingChances;
    _taskImage = taskImage;
    _action = action;
    _function = function;
    _enabled = enabled ?? false;
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

  bool get enabled => _enabled;

  void doTask() {
    if (_function != null) {
      _function();
    }
  }
}
