import 'package:flutter/material.dart';
import 'package:mysql_uz_v1/component/content_widget.dart';
import 'package:mysql_uz_v1/model/user_model.dart';
import 'package:mysql_uz_v1/pages/news.dart';
import 'package:mysql_uz_v1/pages/problems.dart';
import 'package:mysql_uz_v1/pages/tasks.dart';
import 'package:mysql_uz_v1/utilits/menu_bool.dart';
import 'package:mysql_uz_v1/utilits/shared_preference.dart';

class Home extends StatefulWidget {
  final int selectindex;

  Home({this.selectindex});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    ContentWidget(myWidget: News(), color: Colors.white),
    ContentWidget(myWidget: Problems(), color: Colors.white),
    ContentWidget(myWidget: TaskPage(), color: Colors.white),
    ContentWidget(myWidget: News(), color: Colors.white),
  ];

  Future<User> getUserData() async {
    return await UserPreferences().getUser();
  }

  @override
  void initState() {
    if(widget.selectindex != null) {
      setState(() {
        _currentIndex = widget.selectindex;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer:  Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
             MenuButtonBool(),
          ],
        ),
      ),
      appBar: AppBar(
        leadingWidth: 30.0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.black,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.white,
        // leading: ,
        title: Container(
          child: Image.asset('assets/mysql.png', width: 50.0,)
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: FutureBuilder(
                future: getUserData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  User user = snapshot.data;
                  if (user != null && user.authToken != null){
                    return Row(
                      children: [
                        Text("${user.fullName}", style: TextStyle(color: Colors.black),),
                        (user.avatar.isNotEmpty && user.avatar != null) ?
                          Container(width: 60.0, height: 60.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "${user.avatar}"
                          )
                        )),) :
                        Image.asset("assets/images/account.png")
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Text("", style: TextStyle(color: Colors.black),),
                        Image.asset('assets/images/account.png', width: 30,)
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body:  _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        unselectedIconTheme: IconThemeData(color: Color(0xFF336E7B), opacity: 8.0, size: 30),
        selectedIconTheme: IconThemeData(color: Color(0xFF536E7B), opacity: 8.0, size: 30),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ""
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.report_problem),
              label: ""
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
           label: ""
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ""
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
