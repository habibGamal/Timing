import 'package:ecommerce/colors.dart';
import 'package:ecommerce/models/task.dart';
import 'package:ecommerce/models/week_day.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/modal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DayTasks extends StatefulWidget {
  final WeekDay weekDay;
  const DayTasks(this.weekDay, {Key? key}) : super(key: key);
  @override
  State<DayTasks> createState() => _DayTasksState();
}

class _DayTasksState extends State<DayTasks> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool selectTasks = false;
  void addNewTask() {
    if (_controller.value.text.isNotEmpty) {
      Provider.of<Store>(context, listen: false).addNewTask(
          Task(name: _controller.value.text, weekDayId: widget.weekDay.id));
      _controller.clear();
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.weekDay.name} Tasks'),
        backgroundColor: widget.weekDay.color,
        actions: [
          if (selectTasks)
            IconButton(
              onPressed: () {
                Provider.of<Store>(context, listen: false).moveTasksToAchive();
                setState(() {
                  selectTasks = false;
                });
              },
              icon: const Icon(Icons.done_all),
            ),
          if (widget.weekDay.id != WeekDay.achivements)
            IconButton(
              onPressed: () {
                setState(() {
                  selectTasks = !selectTasks;
                });
              },
              icon: selectTasks
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
            ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Consumer<Store>(
              builder: ((context, store, child) {
                final tasks = store.weekDays
                    .firstWhere((weekDay) => weekDay.id == widget.weekDay.id)
                    .tasks;
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.decelerate);
                });
                return ListView(
                  children: tasks
                      .map((task) => TaskWidget(
                            task,
                            selectable: selectTasks,
                            key: Key(task.id.toString()),
                          ))
                      .toList(),
                  controller: _scrollController,
                );
              }),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    cursorColor: MyColors.vilot,
                    onEditingComplete: addNewTask,
                  ),
                ),
                ElevatedButton(onPressed: addNewTask, child: Text('Push'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  final Task task;
  final bool selectable;
  const TaskWidget(
    this.task, {
    this.selectable = false,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  double _scale = 1;
  bool selected = false;
  late bool _done = _percent == 1;
  late final _screenWidth = MediaQuery.of(context).size.width;
  late final _task = widget.task;
  late final _achived = widget.task.weekDayId == WeekDay.achivements;
  // if this task in achivements then it is done = 100%
  late double _percent = _achived ? 1 : _task.percent;

  @override
  Widget build(BuildContext context) {
    if (!widget.selectable && selected) {
      setState(() {
        selected = false;
      });
      Provider.of<Store>(context, listen: false).removeTaskFromAchive(_task);
    }
    return GestureDetector(
      onTap: () {
        if (widget.selectable) {
          setState(() {
            selected = !selected;
            selected
                ? Provider.of<Store>(context, listen: false)
                    .moveTaskToAchive(_task)
                : Provider.of<Store>(context, listen: false)
                    .removeTaskFromAchive(_task);
          });
        }
      },
      onLongPressStart: (details) {
        if (!_achived) {
          setState(() {
            _scale = 1.05;
            _percent = details.globalPosition.dx / _screenWidth;
          });
        }
      },
      onLongPressMoveUpdate: (details) {
        if (!_achived) {
          setState(() {
            _percent = details.globalPosition.dx / _screenWidth;
            if (details.globalPosition.dx / _screenWidth > .95) {
              _percent = 1;
            }
            if (details.globalPosition.dx / _screenWidth < .1) {
              _percent = 0;
            }
            _done = _percent == 1;
          });
        }
      },
      onLongPressEnd: (details) {
        if (!_achived) {
          setState(() {
            _scale = 1;
          });
          Provider.of<Store>(context, listen: false).editTask(
              _task,
              Task(
                  name: _task.name,
                  weekDayId: _task.weekDayId,
                  percent: _percent));
        }
      },
      onDoubleTap: () {
        Navigator.of(context).push(Modal(builder: (context) {
          return EditTask(
            _task,
            achived: _achived,
          );
        }));
      },
      child: AnimatedScale(
        scale: _scale,
        alignment: Alignment.topLeft,
        duration: Duration(milliseconds: 200),
        child: Container(
          height: 55,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 110),
                curve: Curves.decelerate,
                width: _percent * _screenWidth,
                height: 55,
                color: Color.fromARGB(255, 31, 29, 136),
                foregroundDecoration: BoxDecoration(
                    color: selected ? MyColors.red : MyColors.vilot),
              ),
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: selected ? MyColors.red : Colors.black38,
                leading: _done
                    ? const Icon(FontAwesomeIcons.checkSquare)
                    : const Icon(FontAwesomeIcons.square),
                title: Text(_task.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTask extends StatefulWidget {
  final Task task;
  final bool achived;
  const EditTask(
    this.task, {
    this.achived = false,
    Key? key,
  }) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _moreIconBtn = GlobalKey();
  late final _controller = TextEditingController()
    ..value = TextEditingValue(text: widget.task.name);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
              color: MyColors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    cursorColor: MyColors.vilot,
                    // autofocus: true,
                    onEditingComplete: () {},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                          onPressed: () {
                            Provider.of<Store>(context, listen: false).editTask(
                                widget.task,
                                Task(
                                    name: _controller.value.text,
                                    weekDayId: widget.task.weekDayId));
                            Navigator.of(context).pop();
                          },
                          child: Text('Edit')),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: OutlinedButton(
                          onPressed: () {
                            Provider.of<Store>(context, listen: false)
                                .deleteTask(widget.task);
                            Navigator.of(context).pop();
                          },
                          child: Text('delete')),
                    ),
                    if (!widget.achived)
                      IconButton(
                        key: _moreIconBtn,
                        onPressed: () {
                          RenderBox box = _moreIconBtn.currentContext!
                              .findRenderObject() as RenderBox;
                          double h = double.parse(box.size.height.toString());
                          double w = double.parse(box.size.width.toString());
                          Offset position = box.localToGlobal(
                              Offset.zero); //this is global position
                          double y = position.dy;
                          double x = position.dx;
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                x - w,
                                y + h,
                                0,
                                0,
                              ),
                              items: [
                                if (widget.task.weekDayId != WeekDay.unplaced &&
                                    widget.task.weekDayId != WeekDay.lateTasks)
                                  PopupMenuItem(
                                    child: Text('To NextDay'),
                                    onTap: () {
                                      Provider.of<Store>(context, listen: false)
                                          .moveTaskTo(widget.task,
                                              widget.task.weekDayId + 1);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                if (widget.task.weekDayId != WeekDay.unplaced)
                                  PopupMenuItem(
                                    child: Text('To Unplaced'),
                                    onTap: () {
                                      Provider.of<Store>(context, listen: false)
                                          .moveTaskTo(
                                              widget.task, WeekDay.unplaced);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                if (widget.task.weekDayId != WeekDay.lateTasks)
                                  PopupMenuItem(
                                    child: Text('To Late tasks'),
                                    onTap: () {
                                      Provider.of<Store>(context, listen: false)
                                          .moveTaskTo(
                                              widget.task, WeekDay.lateTasks);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                              ]);
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
