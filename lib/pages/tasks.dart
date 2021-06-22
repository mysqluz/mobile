
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql_uz_v1/model/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_uz_v1/model/user_model.dart';
import 'package:mysql_uz_v1/utilits/url.dart';

class TaskPage extends StatefulWidget {

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<TaskModel> tasks = [];
  int perpage = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _getTasks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          perpage += 12;
        });

        _getTasks();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _getTasks() async {
    final http.Response response = await http.get(
        Uri.parse("${AppUrl.tasks}?limit=12&offset=$perpage"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    // print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('No connect');
    } else {
      responseData['results'].forEach((task) {
        final TaskModel taskModel = TaskModel(
            id: task['id'],
            status_text: task['status_text'],
            status: task['status'],
            problem: task['problem'],
            user: User(
              id: task['user']['id'],
              ball: task['user']['ball'],
              avatar: task['user']['avatar'],
              username: task['user']['username'],
              fullName: task['user']['fullname']
            )
        );

        setState(() {
          tasks.add(taskModel);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(tasks.length == 0) {
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: Color(0xFF336E7B),
                  size: 100.0,
                ),
              ),
            );
          } else {
            return ListView.builder(
                controller: _scrollController,
                itemCount: tasks.length,
                itemBuilder: _listViewItemBuilder
            );
          }
        }
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var tasksModel = tasks[index];
    return ListTile(
      onTap: () {
        print("bbbb");
      },
      contentPadding: EdgeInsets.all(10.0),
      leading: _itemThumbnail(tasksModel),
      title: _itemTitle(tasksModel),
    );
  }

  Widget _itemThumbnail(TaskModel taskModel) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: taskModel.user.avatar != null ?
      Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "${taskModel.user.avatar}"
                      )
      ))) :
      Image.asset("assets/images/account.png")
    );
  }

  Widget _itemTitle(TaskModel taskModel) {
    Color _color;

    switch(taskModel.status){
      case -2:
        _color = Colors.blueAccent;
        break;
      case 1:
        _color = Colors.green;
        break;
      default:
        _color = Colors.red;
    }

    Widget statusTask = Text(taskModel.status_text.substring(0, 2),
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _color
      ),
    );

    return Row(
      children: [
        Text("#${taskModel.id}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Color(0xFF336E7B)),
        ),
        Expanded(child: statusTask),
        Text("${taskModel.problem['title']}",
          overflow: TextOverflow.ellipsis,
        ),
        Expanded(
          child: TextButton(onPressed: () {
            print("fvgjrng");
          },
            child: Icon(Icons.remove_red_eye, color: Colors.black,),
            style: ButtonStyle(alignment: Alignment.centerRight),),)
      ],
    );
  }
}
