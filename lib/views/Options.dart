import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> with WidgetsBindingObserver {
  bool enablePinCode = false;
  bool enableFingerPrint = false;
  int pinCode = 0;

  //TODO Esta variable eliminarla
  //bool requiredLogin = false;
  bool isLoged = true;

  TextEditingController pinTextFieldController = new TextEditingController();
  TextEditingController oldPinTextFieldController = new TextEditingController();

  @override
  void dispose() {
    log('dispose');
    // Limpia el controlador cuando el Widget se descarte
    pinTextFieldController.dispose();
    oldPinTextFieldController.dispose();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('enablePinCode', enablePinCode);
      prefs.setInt('pin', pinCode);
      prefs.setBool('enableFingerPrint', enableFingerPrint);
    });
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((onValue) {
      enablePinCode = onValue.getBool('enablePinCode');
      //enableFingerPrint = onValue.getBool('enableFingerPrint');
      pinCode = onValue.getInt('pin');
      if (enablePinCode == null) {
        enablePinCode = false;
      }
      if (enableFingerPrint == null) {
        enableFingerPrint = false;
      }
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Aqui pregunto si se reanuda la aplicacion y si esta interfaz es la que esta visible
    if (state == AppLifecycleState.resumed &&
        ModalRoute.of(context).isCurrent) {
      SharedPreferences.getInstance().then((onValue) {
        enablePinCode = onValue.getBool('enablePinCode');
        isLoged = onValue.getBool('isLoged');
        if (!enablePinCode) {
          isLoged = true;
        } else {
          isLoged = false;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoged) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Opciones'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('Seguridad'),
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.fiber_pin),
                title: Text('Utilizar PIN'),
                subtitle:
                    Text('La utilización de un PIN hará su sistema más seguro'),
                trailing: Switch(
                  value: enablePinCode,
                  onChanged: (bool newValue) {
                    enablePinCode = newValue;
                    if (newValue) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text('Establezca un PIN'),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      controller: pinTextFieldController,
                                      //obscureText: true,
                                      //maxLength: 4,
                                      decoration: InputDecoration(
                                          hintText: 'Nuevo PIN'),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.pop(context, null);
                                          pinTextFieldController.clear();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Aceptar'),
                                        onPressed: () {
                                          if (pinTextFieldController
                                                  .text.length ==
                                              4) {
                                            Navigator.pop(context,
                                                pinTextFieldController.text);
                                            pinTextFieldController.clear();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'El PIN debe ser de 4 digitos');
                                            pinTextFieldController.clear();
                                          }
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )).then((resp) {
                        if (resp != null) {
                          setState(() {
                            pinCode = int.parse(resp);
                            enablePinCode = true;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setInt('pin', pinCode);
                          });
                        } else {
                          setState(() {
                            enablePinCode = false;
                          });
                        }
                      });
                    } else {
                      setState(() {});
                    }
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setBool('enablePinCode', enablePinCode);
                    });
                  },
                ),
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                enabled: enablePinCode,
                leading: Icon(Icons.security),
                title: Text('Cambiar PIN'),
                onTap: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => SimpleDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text('Establezca un PIN'),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  controller: oldPinTextFieldController,
                                  obscureText: true,
                                  maxLength: 4,
                                  decoration:
                                      InputDecoration(hintText: 'Anterior PIN'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  controller: pinTextFieldController,
                                  obscureText: true,
                                  maxLength: 4,
                                  decoration:
                                      InputDecoration(hintText: 'Nuevo PIN'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.pop(context, null);
                                      pinTextFieldController.clear();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      if (pinTextFieldController.text.length !=
                                          4) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'El PIN debe ser de 4 digitos');
                                        pinTextFieldController.clear();
                                        oldPinTextFieldController.clear();
                                      }
                                      if (oldPinTextFieldController.text !=
                                          pinCode.toString()) {
                                        Fluttertoast.showToast(
                                            msg: 'PIN anterior incorrecto');
                                        pinTextFieldController.clear();
                                        oldPinTextFieldController.clear();
                                      }
                                      if (pinTextFieldController.text.length ==
                                              4 &&
                                          oldPinTextFieldController.text ==
                                              pinCode.toString()) {
                                        Navigator.pop(context,
                                            pinTextFieldController.text);
                                        pinTextFieldController.clear();
                                        oldPinTextFieldController.clear();
                                        Fluttertoast.showToast(
                                            msg:
                                                'PIN cambiado satisfactoriamente');
                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          )).then((resp) {
                    if (resp != null) {
                      pinCode = int.parse(resp);
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setInt('pin', pinCode);
                      });
                    }
                  });
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                enabled: enablePinCode,
                leading: Icon(Icons.fingerprint),
                subtitle: Text(
                    'La utilización de datos biométricos hará su sistema más seguro.'),
                title: Text('Utilizar huella dactilar'),
                trailing: Switch(
                  value: enableFingerPrint,
                  onChanged: enablePinCode
                      ? (bool newValue) {
                          setState(() {
                            enableFingerPrint = newValue;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setBool(
                                'enableFingerPrint', enableFingerPrint);
                          });
                        }
                      : null,
                ),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ));
    } else {
      return Login(
        notifyParent: refresh,
      );
    }
  }

  refresh() {
    setState(() {
      isLoged = true;
    });
  }
}
