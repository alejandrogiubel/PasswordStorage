import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myapp/services/DatabaseService.dart';
import 'package:myapp/views/About.dart';
import 'package:myapp/views/AddCredential.dart';
import 'package:myapp/views/Login.dart';
import 'package:myapp/views/Options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/CredentialsCardList.dart';
import 'Themes/AppThemes.dart';
import 'models/Credential.dart';

void main() {
  runApp(MaterialApp(
    //theme: AppThemes.defaultTheme,
    title: 'Passtorage',
    //Rutas
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/add': (context) => AddCredential(),
      '/about': (context) => About(),
      '/options': (context) => Options(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //Lista original de todas las credenciales
  Future<List<Credential>> credentials;

  //Copia de las lista de las credenciales, la cual utilizo para el buscar
  Future<List<Credential>> credentialsCopy;

  //Lista de las credenciales no Future
  List<Credential> credentialsList = new List<Credential>();

  //Variable que me dice si se esta buscando una credencial
  bool find = false;

  //Variable que me dice si el usuario esta autemticado
  bool isLoged = true;

  //Variable quue me dice si se requiere autenticacion
  bool requiredLogin = true;

  //Controladores
  final searchBarController = TextEditingController();

  static const menuItems = <String>[
    'Opciones',
    'Acerca de',
  ];

  final List<PopupMenuItem<String>> popupMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    searchBarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((onValue) {
      requiredLogin = onValue.getBool('enablePinCode');
      if (!requiredLogin) {
        isLoged = true;
      } else {
        isLoged = false;
      }
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Aqui pregunto si se reanuda la aplicacion y si esta interfaz es la que esta visible
    if (state == AppLifecycleState.resumed &&
        ModalRoute.of(context).isCurrent) {
      SharedPreferences.getInstance().then((onValue) {
        requiredLogin = onValue.getBool('enablePinCode');
        isLoged = onValue.getBool('isLoged');
        // if (isLoged != null && !isLoged) {
        if (!requiredLogin) {
          isLoged = true;
        } else {
          isLoged = false;
        }
        // }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoged) {
      if (!find) {
        credentials = DatabaseService.getCredentials();
        credentialsCopy = credentials;
      }
      return Scaffold(
        // backgroundColor: Color(0xffE2E9F2),
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Text('Password Storage'),
              Spacer(),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => popupMenuItems,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 30,
                onSelected: (String selectedValue) {
                  switch (selectedValue) {
                    case 'Opciones':
                      {
                        /* Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Options())); */
                        Navigator.pushNamed(context, '/options');
                      }
                      break;

                    case 'Acerca de':
                      {
                        Navigator.pushNamed(context, '/about');
                      }
                      break;
                    // default:
                  }
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              // child: Expanded(
              child: FutureBuilder(
                  future: credentialsCopy,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      credentialsList = snapshot.data;
                      if (credentialsList.isEmpty) {
                        return Center(
                          child: Text(
                            'Ups no hay contenido para mostrar',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        );
                      } else {
                        return CredentialCardList(credentials: snapshot.data);
                      }
                    } else {
                      //TODO Aqui poner un dibujito de que no hay credenciales
                      return Center(
                        child: Text('ERROR'),
                      );
                    }
                  }),
              // ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              height: 70,
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Color(0xfff5f5f5),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.search),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: TextField(
                            decoration:
                                InputDecoration(hintText: 'Buscar credencial'),
                            controller: searchBarController,
                            onChanged: (string) {
                              if (string.isNotEmpty) {
                                credentialsCopy = credentials.then((resp) {
                                  return credentialsCopy =
                                      matchedCredentials(string, resp);
                                });

                                find = true;
                              } else {
                                find = false;
                                credentialsCopy = credentials;
                                credentials.then((onValue) {
                                  credentialsList = onValue;
                                });
                              }
                              setState(() {});
                            },
                          ),
                        )),
                        IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () {
                            searchBarController.clear();
                            credentialsCopy = credentials;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: 'Nueva credencial',
        ),
      );
    } else {
      return Login(
        notifyParent: refresh,
      );
    }
  }

//Metodo para buscar las credenciales que coincidan
  Future<List<Credential>> matchedCredentials(
      String match, List<Credential> credentials) async {
    List<Credential> matchedCredentialsList = new List<Credential>();
    for (var i = 0; i < credentials.length; i++) {
      if (credentials[i].name.toLowerCase().contains(match.toLowerCase())) {
        matchedCredentialsList.add(credentials[i]);
      }
    }
    return matchedCredentialsList;
  }

  refresh() {
    setState(() {
      isLoged = true;
    });
  }
}
