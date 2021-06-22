import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql_uz_v1/model/problems_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_uz_v1/pages/problems_more_data.dart';
import 'package:mysql_uz_v1/utilits/url.dart';


class Problems extends StatefulWidget {

  @override
  _ProblemsState createState() => _ProblemsState();
}

class _ProblemsState extends State<Problems> {
  ScrollController _scrollController = new ScrollController();
  final List<ProblemsModel> items = [];
  int perpage = 0;

  @override
  void initState() {
    _getNews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          perpage += 12;
        });
        _getNews();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(items.length == 0) {
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
            itemCount: this.items.length,
            itemBuilder: _listViewItemBuilder
        );
      }});
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var problemsModel = this.items[index];
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => ProblemDetail(id: problemsModel.id)));
      },
      contentPadding: EdgeInsets.all(10.0),
      title: _itemTitle(problemsModel),
    );
  }

  // Widget _itemThumbnail(ProblemsModel newsModel) {
  //   return Container(
  //     constraints: BoxConstraints.tightFor(width: 100.0),
  //     child: newsModel.image == null ? Image.asset(
  //         'assets/images/news.jpg', fit: BoxFit.fitWidth) : Image.network(
  //         newsModel.image, fit: BoxFit.fitWidth),
  //   );
  // }

  Widget _itemTitle(ProblemsModel problemsModel) {
    return Row(
      children: [
        Expanded(child: Text("#${problemsModel.id}",
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Color(0xFF336E7B)),
        )),
        Expanded(child: Text(problemsModel.title,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        Expanded(child: Text("Ball : ${problemsModel.ball}",
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        )),
        Expanded(
          child: TextButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => ProblemDetail(id: problemsModel.id)));
          },
            child: Icon(Icons.remove_red_eye, color: Colors.black,),
            style: ButtonStyle(alignment: Alignment.centerRight),),)
      ],
    );
  }

  _getNews() async {
    final http.Response response = await http.get(
        Uri.parse("${AppUrl.problems}?limit=12&offset=$perpage"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception('No connect');
    } else {
      responseData['results'].forEach((problems) {
        final ProblemsModel problemsModel = ProblemsModel(
            id: problems['id'],
            title: problems['title'],
            category: problems['category'],
            content: problems['content'],
            accepted: problems['accepted'],
            author: problems['author'],
            ball: problems['ball']
        );

        setState(() {
          items.add(problemsModel);
        });
      });
    }
  }
}