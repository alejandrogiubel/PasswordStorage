import 'package:flutter/material.dart';
import 'package:myapp/Components/CredentialCard.dart';
import 'package:myapp/models/Credential.dart';

class CredentialCardList extends StatefulWidget {
  final List<Credential> credentials;

  @override
  _CredentialCardListState createState() => _CredentialCardListState();

  CredentialCardList({this.credentials});
}

class _CredentialCardListState extends State<CredentialCardList>{

  //@override
  //void didChangeAppLifecycleState(AppLifecycleState state) {
    //if(state == AppLifecycleState.resumed){
      //setState(() {
      //  credentials = DatabaseService.getCredentials();
     // });
   // }
  //}

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
    setState(() {
      //credentials = DatabaseService.getCredentials();
    });
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
   // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(15, 70, 15, 0),
      itemCount: widget.credentials.length,
      itemBuilder: (BuildContext context, int index) {
        return CredentialCard(
          Credential(
            id: widget.credentials[index].id,
            name: widget.credentials[index].name.toString(),
            userName: widget.credentials[index].userName.toString(),
            password: widget.credentials[index].password.toString()
          )
        );
      }
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   //credentials = DatabaseService.getCredentials();
  //   return FutureBuilder(
  //     future: credentials,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData){
  //         List<Credential> credentials = snapshot.data;
  //         return ListView.builder(
  //           padding: const EdgeInsets.all(8),
  //           itemCount: credentials.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return CredentialCard(
  //               Credential(
  //                 id: credentials[index].id,
  //                 name: credentials[index].name.toString(),
  //                 userName: credentials[index].userName.toString(),
  //                 password: credentials[index].password.toString()
  //               )
  //             );
  //           }
  //         );
  //       }
  //       else{
  //         return Center(child: Text('No hay credenciales'),);
  //       }
  //     }
  //   );
  // }
}
