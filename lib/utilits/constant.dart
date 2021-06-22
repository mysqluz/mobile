
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);


final loginOrRegisterButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
        Colors.white
    ),
    padding: MaterialStateProperty.all(
        EdgeInsets.all(15.0)
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      ),
    )
);

final loaderInAllPage = SpinKitDoubleBounce(
  color: Color(0xFF336E7B),
  size: 100.0,
);