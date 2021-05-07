import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/pages/register_page.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/auth_header.dart';
import 'package:shoppingapp/widgets/login/Confirm.dart';
import 'package:shoppingapp/widgets/login/LoginModel.dart';
import 'package:shoppingapp/widgets/login/login_form.dart';
import 'package:shoppingapp/widgets/login/social_auth_login.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _showpassword = false;
  bool _request = false;


  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: mainColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AuthHeader(
                  headerTitle: "Login",
                  headerBigTitle: "New",
                  isLoginHeader: true),
              SizedBox(
                height: 36,
                width: 100,
              ),
              LoginForm(),
              // SizedBox(
              //   height: 8,
              //   child: RaisedButton(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //     color: Colors.white,
              //     onPressed: () async {
              //       String phone = emailController.text.toString();
              //       LoginModel login = await Login(phone);
              //       if (login.success) {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => Confirm(
              //                   phone: emailController.text.toString())),
              //         );
              //       }
              //     },
              //     // child: new Text(
              //     //   getTranslated(context, 'login'),
              //     //   style: TextStyle(fontSize: 22.0),
              //     // ),
              //   ),
              // ),
              routeRegisterWidget(themeColor, context),
              // SocialLoginButtons(themeColor: themeColor)
            ],
          ),
        ),
      ),
    );
  }

  Future<LoginModel> Login(String phone) async {
    String url = "http://3.123.153.179/client/login-request";
    final respons =
    await http.post(url, body: {"phone": phone, "user_type": "client"});
    if (respons.statusCode == 200 || respons.statusCode == 201) {
      final String responseString = respons.body;
      return loginModelFromJson(responseString);
    } else if (respons.statusCode == 401) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage(phone: phone)),
      );
    } else {
      return null;
    }
  }

  routeRegisterWidget(ThemeNotifier themeColor, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 42, left: 42, bottom: 12),
      child: Row(
        children: <Widget>[
          Text(
            "Do you have an account?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),
          ),
          FlatButton(
            child: Text(
              "Register",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: themeColor.getColor(),
                fontWeight: FontWeight.w300,
              ),
            ),
            onPressed: () {
              Nav.routeReplacement(context, RegisterPage());
            },
          )
        ],
      ),
    );
  }
}
