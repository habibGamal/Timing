import 'package:ecommerce/fake_data.dart' as fake;
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/models/session.dart';
import 'package:ecommerce/models/task.dart';
import 'package:ecommerce/models/week_day.dart';
import 'package:ecommerce/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _blockTimeHour = 0;
  int _blockTimeMin = 45;
  late List<Mode> _modes;
  late List<Session> _sessions;
  late List<Session> _sessionsFrom;
  Mode _currentMode = fake.modes.first;
  final List<WeekDay> _weekDays = [
    WeekDay(
      id: 1,
      name: 'Saturday',
      color: Color.fromARGB(255, 44, 62, 80),
      tasks: [],
    ),
    WeekDay(
      id: 2,
      name: 'Sunday',
      color: Color.fromARGB(255, 241, 196, 15),
      tasks: [],
    ),
    WeekDay(
      id: 3,
      name: 'Monday',
      color: Color.fromARGB(255, 41, 128, 185),
      tasks: [],
    ),
    WeekDay(
      id: 4,
      name: 'Tuesday',
      color: Color.fromARGB(255, 183, 21, 64),
      tasks: [],
    ),
    WeekDay(
      id: 5,
      name: 'Wednesday',
      color: Color.fromARGB(255, 39, 174, 96),
      tasks: [],
    ),
    WeekDay(
      id: 6,
      name: 'Thursday',
      color: Color.fromARGB(255, 12, 36, 97),
      tasks: [],
    ),
    WeekDay(
      id: 7,
      name: 'Friday',
      color: Color.fromARGB(255, 91, 22, 71),
      tasks: [],
    ),
    WeekDay(
      id: WeekDay.unplaced,
      name: 'Unplaced',
      color: Color.fromARGB(255, 0, 0, 0),
      tasks: [],
    ),
    WeekDay(
      id: WeekDay.lateTasks,
      name: 'Late Tasks',
      color: Color.fromARGB(255, 0, 0, 0),
      tasks: [],
    ),
    WeekDay(
      id: WeekDay.achivements,
      name: 'Achivements',
      color: Color.fromARGB(255, 0, 0, 0),
      tasks: [],
    ),
  ];
  final List<Task> _moveToAchivements = [];
  Store() {
    // initialize the block time
    _prefs.then((prefs) {
      _blockTimeHour = prefs.getInt(Prefs.blockTimeHours) ?? 0;
      _blockTimeMin = prefs.getInt(Prefs.blockTimeMin) ?? 45;
      notifyListeners();
    });
    // initialize modes
    Mode.getAll().then((modes) {
      _modes = modes;
      _currentMode = modes.first;
      notifyListeners();
    });
    // initialize sessions
    Session.getAll().then((sessions) {
      _sessionsFrom = _sessions = sessions;
      notifyListeners();
    });
    // initialize tasks
    Task.getAll().then((tasks) {
      for (Task task in tasks) {
        final index = _weekDays.indexWhere((day) => day.id == task.weekDayId);
        _weekDays[index].tasks.add(task);
      }
      notifyListeners();
    });
  }
  int get blockTimeHour => _blockTimeHour;
  int get blockTimeMin => _blockTimeMin;
  List<Mode> get modes => _modes;
  List<Session> get sessions => _sessions;
  List<Session> get sessionsFrom => _sessionsFrom;
  Mode get currentMode => _currentMode;
  List<WeekDay> get weekDays => _weekDays;

  // Block Time
  saveBlockTimeHour(int hours) {
    _blockTimeHour = hours;
    _prefs.then((prefs) => prefs.setInt(Prefs.blockTimeHours, hours));
  }

  saveBlockTimeMin(int min) {
    _blockTimeMin = min;
    _prefs.then((prefs) => prefs.setInt(Prefs.blockTimeMin, min));
  }

  setBlockTimeHour(int hours) {
    saveBlockTimeHour(hours);
    notifyListeners();
  }

  setBlockTimeMin(int min) {
    saveBlockTimeMin(min);
    notifyListeners();
  }

  // Mode
  Mode getModeById(int id) {
    return _modes.singleWhere((element) => element.id == id);
  }

  syncStoreWithDBModes() async {
    await Mode.getAll().then((modes) {
      _modes = modes;
    });
  }

  setCurrentMode(Mode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  addNewMode(Mode mode) async {
    await Mode.insert(mode.toMap());
    await syncStoreWithDBModes();
    notifyListeners();
  }

  editMode(int id, Mode mode) async {
    final oldMode = _modes.firstWhere((element) => element.id == id);
    oldMode.update(mode.toMap());
    await syncStoreWithDBModes();
    notifyListeners();
  }

  deleteMode(int id) async {
    final mode = _modes.firstWhere((element) => element.id == id);
    mode.delete();
    await syncStoreWithDBModes();
    // update history
    final sessionsToDelete = _sessions.where((session) => session.modeId == id);
    Session.deleteGroup(sessionsToDelete.map((e) => e.id!).toList());
    await syncStoreWithDBHistory();
    _sessionsFrom = _sessions;
    _currentMode = _modes.first;
    notifyListeners();
  }

  // session
  syncStoreWithDBHistory() async {
    await Session.getAll().then((sessions) {
      _sessions = sessions;
    });
  }

  setSessionsFrom(date) async {
    _sessionsFrom =
        _sessions.where((session) => session.getDate.isAfter(date)).toList();
    notifyListeners();
  }

  addNewSession(Session session) async {
    await Session.insert(session.toMap());
    await syncStoreWithDBHistory();
    notifyListeners();
  }

  editSession(int id, Session session) async {
    final oldSession = _sessions.firstWhere((element) => element.id == id);
    oldSession.update(session.toMap());
    await syncStoreWithDBHistory();
    notifyListeners();
  }

  deleteSession(int id) async {
    final check = await Session.delete(id);
    if (check == 1) {
      _sessions.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  // tasks
  syncStoreWithDBTasks() async {
    await Task.getAll().then((tasks) {
      for (Task task in tasks) {
        final index = _weekDays.indexWhere((day) => day.id == task.weekDayId);
        _weekDays[index].tasks.add(task);
      }
    });
  }

  addNewTask(Task task) async {
    final id = await Task.insert(task.toMap());
    task.id = id;
    final index = _weekDays.indexWhere((day) => day.id == task.weekDayId);
    _weekDays[index].tasks.add(task);
    notifyListeners();
  }

  editTask(Task task, Task newTask) async {
    await task.update(newTask);
    notifyListeners();
  }

  moveTaskTo(Task task, int weekDayId, {bool notifiy = true}) async {
    if (weekDayId != task.weekDayId) {
      // remove the task from the original place
      final oldIndex = _weekDays.indexWhere((day) => day.id == task.weekDayId);
      _weekDays[oldIndex].tasks.removeWhere((element) => element.id == task.id);
      // move the task to the new place
      // if it is the last day in the week
      if (weekDayId == WeekDay.daysEnd) {
        // make it the first day in the next week
        weekDayId = WeekDay.daysStart;
      }
      final index = _weekDays.indexWhere((day) => day.id == weekDayId);
      _weekDays[index].tasks.add(task);
    }
    await task.moveTo(weekDayId);
    if (notifiy) {
      notifyListeners();
    }
  }

  moveTasksToAchive() {
    // do magic here
    for (Task task in _moveToAchivements) {
      moveTaskTo(task, WeekDay.achivements, notifiy: false);
    }
    notifyListeners();
  }

  moveTaskToAchive(Task task) {
    _moveToAchivements.add(task);
  }

  removeTaskFromAchive(Task task) {
    _moveToAchivements.remove(task);
  }

  deleteTask(Task task) async {
    await Task.delete(task.id);
    final index =
        _weekDays.indexWhere((element) => element.id == task.weekDayId);
    _weekDays[index].tasks.removeWhere((element) => element.id == task.id);
    notifyListeners();
  }
}
