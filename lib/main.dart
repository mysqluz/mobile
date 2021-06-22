import 'package:flutter/material.dart';
import 'package:mysql_uz_v1/pages/login.dart';
import 'package:mysql_uz_v1/pages/register.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MySql());
}

class MySql extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: _onGenerateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":{
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
    }
    case "/register":{
      return MaterialPageRoute(builder: (BuildContext context) {
        return RegisterScreen();
      });
    }

    case "/login": {
      return MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
      });
    }

    case "/tasks": {
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home(selectindex: 2,);
      });
    }
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
  }
}


