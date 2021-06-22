import 'package:flutter/material.dart';

class NewsModel{
  final int id;
  final String title;
  final String content;
  final String image;
  final String slug;

NewsModel({@required this.id, @required this.title, @required this.content, @required this.image, @required this.slug});
}