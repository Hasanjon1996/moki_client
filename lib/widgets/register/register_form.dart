import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/utils/navigator.dart';
import 'package:shoppingapp/utils/screen.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shoppingapp/widgets/commons/shadow_button.dart';
import 'package:shoppingapp/widgets/login/Confirm.dart';
import 'package:shoppingapp/widgets/register/register_form_model.dart';
import 'package:shoppingapp/widgets/login/LoginModel.dart';
import 'package:shoppingapp/pages/register_page.dart';
import 'package:validators/validators.dart' as validator;
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../commons/custom_textfield.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
      padding: EdgeInsets.only(top: 24, right: 36, left: 48),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: MyTextFormField(
                labelText: "First Name",
                hintText: 'First Name',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter your first name';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.firstName = value;
                },
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: MyTextFormField(
                labelText: "Last Name",
                hintText: 'Last Name',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter your last name';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.lastName = value;
                },
              ),
            ),
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
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  color: themeColor.getColor(),
                  onPressed: () {
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
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
