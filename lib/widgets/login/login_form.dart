import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/main.dart';
import 'package:shoppingapp/pages/register_page.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/screen.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/shadow_button.dart';
import 'package:shoppingapp/widgets/login/Confirm.dart';
import 'package:shoppingapp/widgets/login/Model.dart';
import 'package:validators/validators.dart' as validator;
import 'package:http/http.dart' as http;

import '../commons/custom_textfield.dart';
import 'LoginModel.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Model model = Model();
  bool passwordVisible = false;
  bool showpassword = false;
  bool request = false;

  @override
  void initState() {
    super.initState();
  }


  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    return Container(
      padding: EdgeInsets.only(top: 24, right: 42, left: 42),
      child: Form(
        key: _formKey,
                child: Column(
                children: <Widget>[
                     MyTextFormField(
                     labelText: "Phone",
                      hintText: 'Phone',
                      validator: (String value) {
                      if (!validator.isNumeric(value)) {
                      return 'Please enter a valid phone';
    }
                      return null;
              },
              onSaved: (String value) {
                model.email = value;
              },
            ),
            // MyTextFormField(
            //   labelText: "Password",
            //   hintText: 'Password',
            //   suffixIcon: IconButton(
            //     icon: Icon(
            //       // Based on passwordVisible state choose the icon
            //       passwordVisible ? Icons.visibility : Icons.visibility_off,
            //       color: themeColor.getColor(),
            //     ),
            //     onPressed: () {
            //       // Update the state i.e. toogle the state of passwordVisible variable
            //       setState(() {
            //         passwordVisible = !passwordVisible;
            //       });
            //     },
            //   ),
            //   isPassword: passwordVisible,
            //   validator: (String value) {
            //     if (value.length < 7) {
            //       return 'Password should be minimum 7 characters';
            //     }
            //
            //     _formKey.currentState.save();
            //
            //     return null;
            //   },
            //   onSaved: (String value) {
            //     model.password = value;
            //   },
            // ),
            Container(
              height: 48,
              width: ScreenUtil.getWidth(context),
              margin: EdgeInsets.only(top: 12, bottom: 0),
              child: ShadowButton(
                borderRadius: 12,
                height: 40,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.red,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Nav.routeReplacement(context, Confirm(
                        phone: emailController.text.toString()));
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => Result()));

                  }
                },
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // child: new Text(
                //   getTranslated(context, 'login'),
                //   style: TextStyle(fontSize: 22.0),
                // ),
              ),
              ),
            ),
          ],
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
}
