import 'package:flutter/material.dart';

class ProblemsModel{

  ProblemsModel({
    @required this.id,
    @required this.accepted,
    @required this.title,
    @required this.content,
    @required this.ball,
    @required this.category,
    @required this.author
  });

  factory ProblemsModel.fromJson(Map<dynamic, dynamic> json) =>
    ProblemsModel(
      id: json['id'],
      accepted: json['accepted'],
      title: json['title'],
      content: json['content'],
      ball: json['ball'],
      category: json['category'],
      author: json['author']
    );

  final int id;
  final bool accepted;
  final String content;
  final String title;
  final int ball;
  final int category;
  final int author;
}