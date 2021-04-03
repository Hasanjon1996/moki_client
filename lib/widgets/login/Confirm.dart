import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/main.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/C.dart';
import 'package:shoppingapp/widgets/login/Model.dart';

import '../../config.dart';

class Confirm extends StatelessWidget {
  String phone;
  TextEditingController Controller = new TextEditingController();
  Confirm({Key key, @required this.phone}) : super(key: key);

  Future<Model> Complete(String phone, String sms) async {
    String url = "http://3.123.153.179/client/login-complete";
    final respons =
    await http.post(url, body: {"phone": phone, "sms_code": sms});
    if (respons.statusCode == 200 || respons.statusCode == 201) {
      final String responseString = respons.body;
      return ModelFromJson(responseString);
    } else {
      return null;
    }
  }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm'),
      ),
      body: Center(
          child: Column(
            children: [
              Text('Tasdiqlash kodi $phone ga jo\'natildi',
                  style: new TextStyle(fontSize: 22)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 100,
                    height: 200,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.headline6,
                      controller: Controller,
                      decoration: InputDecoration(
                          hintText: 'Code',
                          border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Model sms = await Complete(phone, Controller.text);
                  if (sms != null) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString(C.ACCESS_TOKEN, sms.authKey);

                    prefs.commit();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => InitPage()),
                            (route) => false);
                  }
                },
                child: new Text('send'),
              )
            ],
          )),
    );
  }
  // routeRegisterWidget(ThemeNotifier themeColor, BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.only(right: 42, left: 42, bottom: 12),
  //     child: Row(
  //       children: <Widget>[
  //         Text(
  //           "Do you have an account?",
  //           style: GoogleFonts.poppins(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w200,
  //           ),
  //         ),
  //         FlatButton(
  //           child: Text(
  //             "Register",
  //             style: GoogleFonts.poppins(
  //               fontSize: 14,
  //               color: themeColor.getColor(),
  //               fontWeight: FontWeight.w300,
  //             ),
  //           ),
  //           onPressed: () {
  //             Nav.routeReplacement(context, RegisterPage());
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
