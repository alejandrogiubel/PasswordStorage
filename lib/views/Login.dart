import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final Function() notifyParent;

  @override
  _LoginState createState() => _LoginState();

  Login({Key key, this.notifyParent }) : super(key: key);
}

class _LoginState extends State<Login> {
  int pin;
  final pinTextInputController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      pin = prefs.getInt('pin');
      log('$pin');
    });
    
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: pinTextInputController,
              // showCursor: false,
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 20,
              ),
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'PIN',
                counter: Offstage(),
                // labelText: 'Introduzca su PIN',
                labelStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  letterSpacing: 1,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.teal
                  )
                ),
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.teal
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                height: 50,
                width: 140,
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Siguiente',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    if (pinTextInputController.text == pin.toString()){
                      var pref = await SharedPreferences.getInstance();
                      pref.setBool('isLoged', true);
                      widget.notifyParent();
                    }
                    else {
                      Fluttertoast.showToast(msg: 'Pin no valido');
                    }
                  },
                ),
              )
            )
          ],
        ),
      )
    );
  }
}