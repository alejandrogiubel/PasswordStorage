import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/models/Credential.dart';
import 'package:myapp/services/DatabaseService.dart';

class AddCredential extends StatefulWidget {

  @override
  _AddCredentialState createState() => _AddCredentialState();

}

class _AddCredentialState extends State<AddCredential> {
  bool showPassword = false;
  final nameTextFieldController = TextEditingController();
  final userNameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    nameTextFieldController.dispose();
    userNameTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Credencial'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameTextFieldController,
                decoration: InputDecoration(
                  labelText: 'Credencial',
                  hintText: 'Nombre de la credencial'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: userNameTextFieldController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  hintText: 'Nombre de usuario'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: !showPassword,
                controller: passwordTextFieldController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: showPassword ? Theme.of(context).primaryColor : Colors.grey,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        DatabaseService.insertCredential(
                          new Credential(
                            name: nameTextFieldController.text,
                            userName: userNameTextFieldController.text,
                            password: passwordTextFieldController.text
                          )
                        );
                        Fluttertoast.showToast(
                          msg: 'Credencial guardada',
                          //toastLength: Toast.LENGTH_SHORT,
                          //gravity: ToastGravity.BOTTOM,
                          //timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          //textColor: Colors.white,
                          //fontSize: 16.0
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Guardar',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 20,
                      splashColor: Colors.red,

                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

}