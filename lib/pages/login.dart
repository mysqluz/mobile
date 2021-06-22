import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql_uz_v1/providers/auth.dart';
import 'package:mysql_uz_v1/utilits/constant.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  String _username, _password;
  bool isLoading = false;
  Widget _userName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Foydalanuvchi nomi', style: kLabelStyle),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty ? "Iltimos foydalanuvchi nomini kiriting" : null,
            onSaved: (value) {
                _username = value;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(13.0),
                prefix: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: Colors.white,
                ),
                hintText: 'Foydalanuvchi nomi',
                hintStyle: kHintTextStyle
            ),
          ),
        ),
      ],
    );
  }

  Widget _userPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parol', style: kLabelStyle),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty ? 'Iltimos foydalanuvchi parolini kiriting' : null,
            onSaved: (value) {
                _password = value;
            },
            obscureText: true,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(13.0),
                prefix: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Foydalanuvchi paroli',
                hintStyle: kHintTextStyle
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final form = formKey.currentState;

          if (form.validate()){
              form.save();

              try {
                setState(() {
                  isLoading = true;
                });
                var data = await AuthProvider().login(_username, _password);
                var isLoadingFuture = Future.delayed(const Duration(seconds: 2), () {
                  return false;
                });
                isLoadingFuture.then((response) {
                  setState(() {
                    isLoading = response;
                  });
                });
                if(data['status']){
                  Navigator.pushReplacementNamed(context, "/");
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("${data['message']['non_field_errors'][0]}")));
                }
              } on SocketException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Not Internet Connection!!! \n${e.osError}")));
              }
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Iltimos formani to'diring")));
          }
        },
        style: loginOrRegisterButton,

        child: Text(
          'Kirish',
          style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9]
                    )
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/mysql.png', height: 100, width: 100,),
                        SizedBox(height: 20.0,),
                        Text(
                          'Tizimga kirish',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        _userName(),
                        SizedBox(height: 30.0,),
                        _userPassword(),
                        _loginButton(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Siz hali ro'yhatdan o'tmaganmisiz?",
                                  style: TextStyle(
                                     color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400
                                  )
                              ),
                              TextSpan(
                                  text: "Ro'yhatdan o'tish",
                                  style: TextStyle(
                                     color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                  )
                              )
                            ]
                          )),
                        ),
                        Stack(
                          children: [
                            Positioned(
                              child: isLoading
                                  ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                // color: Colors.white.withOpacity(0.8),
                              ) : Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
