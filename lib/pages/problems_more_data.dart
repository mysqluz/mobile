import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_uz_v1/utilits/shared_preference.dart';
import 'package:mysql_uz_v1/utilits/url.dart';

class ProblemDetail extends StatefulWidget {
  ProblemDetail({@required this.id});
  final int id;
  @override
  _ProblemDetailState createState() => _ProblemDetailState();
}

class _ProblemDetailState extends State<ProblemDetail> {

  ScrollController scrollController = new ScrollController();

  TextEditingController _controller = new TextEditingController();

  String _token;

  Future problemGet() async {
    final http.Response response = await http.get(
        Uri.parse("${AppUrl.problems}${widget.id}/"),
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

  void userData() async {
    String token = await UserPreferences().getToken();
    setState(() {
      _token = token;
    });
  }

  Future problemSend(String token, String source, int problem) async {

    try {
      final http.Response response = await http.post(
          Uri.parse("${AppUrl.tasks}"),
          body: jsonEncode({
            'source': source,
            'problem': problem
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization' : 'Token $token'
          }
      );
      if(response.statusCode != 201){
        throw Exception("Unknow error");
      }else {
        final Map<dynamic, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch(e) {
      return e;
    }
  }

  @override
  void initState() {
    userData();
    super.initState();
  }

  Widget authProblemSubmit() {
    if(_token != null) {
      return Column(
        children: [
          SizedBox(
            width: 400,
            child: TextField(
              controller: _controller,
              onSubmitted: (text) => print(_controller.text),
              autofocus: true,
              cursorColor: Colors.black54,
              style: TextStyle(height: 2.0),
              cursorWidth: 5.0,
              decoration: InputDecoration(
                hintText: "Javobni kiriting",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.amber,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              enabled: true,
              maxLines: 3,
              // maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF336E7B))
            ),
            child: Text('Yuborish'),
            onPressed: () async {
              if(_token != null) {
                if(_controller.text != ""){
                  var data = await problemSend(_token, _controller.text, widget.id);
                  if(data is SocketException){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Ulashnish yo'q: ${data.toString()}")));
                  } else if(data is Exception){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Nomalum xatolik: ${data.toString()}")));
                  } else {
                    Navigator.pushReplacementNamed(context, '/tasks');
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Javobni kiritmadingiz!!!")));
                }
              }
             },
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF336E7B))
          ),
          child: Text("Yechimni yuborish uchun ro'yhatdan o'tish zarur"),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      );
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
        future: problemGet(),

        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null || snapshot.data is Exception) {
            return Container(
                child: Center(
                  child: SpinKitDoubleBounce(
                    color: Color(0xFF336E7B),
                    size: 100.0,
                  ),
                ),
            );
          }else {
            return Scrollbar(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(height: 10.0,),
                  Text("${snapshot.data['title']}", style: TextStyle(fontWeight: FontWeight.bold),),
                  Expanded(child: SingleChildScrollView(
                    child: Html(
                      data: snapshot.data['content'],
                      style: {
                        "table": Style(
                          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                        ),
                        "td" : Style(
                            fontWeight: FontWeight.bold,
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0)
                        ),
                        "tr": Style(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        "th": Style(
                          padding: EdgeInsets.all(6),
                          backgroundColor: Colors.grey,
                        ),
                        "h1" : Style(
                            fontSize: FontSize.medium
                        )
                      },
                      customRender: {
                        "table": (context, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                            (context.tree as TableLayoutElement).toWidget(context),
                          );
                        },
                      },
                    ),
                  )),
                  authProblemSubmit()
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
