import 'package:flutter/material.dart';
import 'package:mysql_uz_v1/model/user_model.dart';

class TaskModel {
  final int id;
  final Map<String, dynamic> problem;
  final User user;
  // ignore: non_constant_identifier_names
  final String status_text;
  final int status;

  // ignore: non_constant_identifier_names
  TaskModel({@required this.id, @required this.problem, @required this.user, @required this.status_text, @required this.status});
}