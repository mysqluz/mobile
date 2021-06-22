import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql_uz_v1/providers/auth.dart';
import 'package:mysql_uz_v1/utilits/constant.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = new GlobalKey<FormState>();
  String _username, _useremail, _password, _fullname, _confirmpassword;
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

  Widget _fullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Foydalanuvchi ismi va familyasi', style: kLabelStyle),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty ? "Iltimos foydalanuvchi to'liq ismini kiriting" : null,
            onSaved: (value) {
              _fullname = value;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(13.0),
                prefix: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                hintText: 'Foydalanuvchi ismi familyasi',
                hintStyle: kHintTextStyle
            ),
          ),
        ),
      ],
    );
  }

  Widget _userEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Foydalanuvchi pochta manzili', style: kLabelStyle),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            // ignore: missing_return
            validator: (value) => getEmailValidation(value),
            onSaved: (value) {
              _useremail = value;
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(13.0),
                prefix: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                hintText: 'Foydalanuvchi pochtasi',
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

  Widget _confirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parolni qayta kiriting', style: kLabelStyle),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty ? 'Iltimos parolni tasdiqlashni kiriting' : null,
            onSaved: (value) {
              _confirmpassword = value;
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
            if(_password != _confirmpassword){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Parol bir xil emas"),));
            } else {
               try {
                 setState(() {
                   isLoading = true;
                 });
                 var res = await AuthProvider().register(_username, _fullname, _useremail, _password, _confirmpassword);

                 var isLoadingFuture = Future.delayed(const Duration(seconds: 2), () {
                   return false;
                 });
                 isLoadingFuture.then((response) {
                   setState(() {
                     isLoading = response;
                   });
                 });
            print(res);
                 if (res['status']) {
                   Navigator.pushReplacementNamed(context, "/");
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ro'yhatdan otishda xatolik yuz berdi!\n ${res['data']}"),));
                 }
               } on Exception catch(e) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nomalum xatolik yuz berdi!\n ${e.toString()}"),));
               }
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

  String getEmailValidation(String value) {
    if (value.isEmpty) {
      return "Iltimos foydalanuvchi pochtasini kiriting kiriting";
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return "Iltimos pochta turida kiriting";
    } else {
      return null;
    }
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
                          "Tizimdan ro'yhatdan o'tish",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        _userName(),
                        SizedBox(height: 30.0,),
                        _userEmail(),
                        SizedBox(height: 30.0,),
                        _fullName(),
                        SizedBox(height: 30.0,),
                        _userPassword(),
                        SizedBox(height: 30.0,),
                        _confirmPassword(),
                        _loginButton(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Siz ro'yhatdan o'tganmisiz? ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400
                                    )
                                ),
                                TextSpan(
                                    text: "Tizimga kirish",
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
