import 'package:flutter/material.dart';
import 'package:mysql_uz_v1/utilits/shared_preference.dart';

class MenuButtonBool extends StatefulWidget {

  @override
  _MenuButtonBoolState createState() => _MenuButtonBoolState();
}

class _MenuButtonBoolState extends State<MenuButtonBool> {

  Future<String> userData() async {
   return await UserPreferences().getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300.0,
      ),
      child: FutureBuilder(
        future: userData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          String str = snapshot.data;
          if(str != null){
            return TextButton(
              onPressed: (){
                    UserPreferences().removeUser();
                    Navigator.pushReplacementNamed(context, '/');
              },
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black,),
                  SizedBox(width: 10,),
                  Text(
                    'Tizimdan chiqish',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return TextButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, "/login");
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.black),
                  SizedBox(width: 10,),
                  Text(
                    'Tizimga kirish',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

