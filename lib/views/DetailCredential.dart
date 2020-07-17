import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/models/Credential.dart';
import 'package:myapp/services/DatabaseService.dart';

class DetailCredential extends StatefulWidget {
  final Credential credential;

  DetailCredential(this.credential);

  @override
  _DetailCredentialState createState() => _DetailCredentialState(credential);
}

class _DetailCredentialState extends State<DetailCredential> {
  final Credential credential;
  

  _DetailCredentialState(this.credential);
  
  final nameTextFildController = TextEditingController();
  final userNameTextFildController = TextEditingController();
  final passwordTextFildController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.nameTextFildController.text = credential.name.toString();
    this.userNameTextFildController.text = credential.userName.toString();
    this.passwordTextFildController.text = credential.password.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text('Modificar ' + credential.name.toString()),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameTextFildController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: userNameTextFildController,
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                controller: passwordTextFildController,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Expanded(
                          Container(
                            height: 40,
                            width: 200,
                            child: RaisedButton(
                              onPressed: () {
                                credential.name = nameTextFildController.text;
                                credential.userName = userNameTextFildController.text;
                                credential.password = passwordTextFildController.text;
                                DatabaseService.updateCredential(credential);
                                Navigator.pop(context, credential);
                              },
                              child: Text('Actualizar',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              color: Colors.blue,
                              textColor: Colors.white,
                              elevation: 20,
                              splashColor: Colors.red,
                            ),
                          )
                        //)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Expanded(
                            Container(
                              height: 40,
                              width: 200,
                              child: RaisedButton(
                                onPressed: () {
                                  DatabaseService.deleteCredential(credential.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Eliminar',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                color: Colors.blue,
                                textColor: Colors.white,
                                elevation: 20,
                                splashColor: Colors.red,
                              ),
                            )
                          //)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
