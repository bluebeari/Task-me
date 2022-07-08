import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskme/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  String? _newTaskContent;
  Box? _box;

  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.13,
        title: const Text(
          "🍓☆ʕ •ᴥ•ʔ🅃🄰🅂🄺⊡🄼🄴ʕ•ᴥ•ʔﾉ♡🍓",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _taskList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
                fontSize: 21,
                color: Colors.deepOrange,
                decoration: task.done ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(
            task.timestamp.toString(),
          ),
          trailing: Icon(
            task.done ? Icons.check_circle_outlined : Icons.circle_outlined,
            size: 37,
            color: Colors.lightGreen,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(_index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add New Task:   (◕ ˬ ◕✿)"),
          content: TextField(
            onSubmitted: (_value) {
              if (_newTaskContent != null) {
                var _task = Task(
                    content: _newTaskContent!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(_task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
              });
            },
          ),
        );
      },
    );
  }
}
