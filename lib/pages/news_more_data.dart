import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_uz_v1/utilits/url.dart';

class NewsDetail extends StatelessWidget {
  final String slug;

  NewsDetail({@required this.slug});

  Future _getNews() async {
    final http.Response response = await http.get(
        Uri.parse("${AppUrl.news}${this.slug}/"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
    );

    if(response.statusCode != 200){
      throw Exception("Unknow error");
    }else {
      final Map<dynamic, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        // leading: ,
        title: Container(
            child: Image.asset('assets/mysql.png', width: 50.0,)
        ),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: _getNews(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null || snapshot is Exception){
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: Color(0xFF336E7B),
                  size: 100.0,
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(child: snapshot.data['image'] == null ? Image.asset('assets/images/news.jpg', fit: BoxFit.fitWidth) : Image.network(snapshot.data['image'], fit: BoxFit.fitWidth),),
                  SizedBox(height: 10.0,),
                  Text(snapshot.data['title'], style: TextStyle(fontWeight: FontWeight.bold),),
                  Expanded(child: Scrollbar(controller: new ScrollController(),child: Html(data: snapshot.data['content'],))),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
