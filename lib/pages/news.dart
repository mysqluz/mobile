import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql_uz_v1/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_uz_v1/pages/news_more_data.dart';
import 'package:mysql_uz_v1/utilits/url.dart';


class News extends StatefulWidget {

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  ScrollController _scrollController = new ScrollController();
  final List<NewsModel> items = [];
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
    var newsDetail = this.items[index];
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => NewsDetail(slug: newsDetail.slug,)));
      },
      contentPadding: EdgeInsets.all(10.0),
      leading: _itemThumbnail(newsDetail),
      title: _itemTitle(newsDetail),
    );
  }

  Widget _itemThumbnail(NewsModel newsModel) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: newsModel.image == null ? Image.asset(
          'assets/images/news.jpg', fit: BoxFit.fitWidth) : Image.network(
          newsModel.image, fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(NewsModel newsModel) {
    return Row(
      children: [
        Expanded(child: Text(newsModel.title,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        )),
        Expanded(
          child: TextButton(onPressed: () {

            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => NewsDetail(slug: newsModel.slug)));
          },
            child: Icon(Icons.remove_red_eye, color: Colors.black,),
            style: ButtonStyle(alignment: Alignment.centerRight),),)
      ],
    );
  }

  _getNews() async {
    final http.Response response = await http.get(
        Uri.parse("${AppUrl.news}?limit=12&offset=$perpage"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception('No connect');
    } else {
      responseData['results'].forEach((news) {
        final NewsModel myNews = NewsModel(
            id: news['id'],
            title: news['title'],
            content: news['content'],
            image: news['image'],
            slug: news['slug']
        );

        setState(() {
          items.add(myNews);
        });
      });
    }
  }
}