import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/Credential.dart';
import 'package:myapp/views/DetailCredential.dart';

class CredentialCard extends StatelessWidget {
  final Credential credential;
  CredentialCard(this.credential);

  final List<Color> colors = [
    Color(0xffffcdd2),
    Color(0xfff06292),
    Color(0xffba68c8),
    Color(0xff9575cd),
    Color(0xff7986cb),
    Color(0xff2196f3),
    Color(0xff0097a7),
    Color(0xff4db6ac),
    Color(0xff81c784),
    Color(0xffaed581),
    Color(0xfffbc02d),
    Color(0xffffc107),
    Color(0xffff8a65),
    Color(0xff90a4ae),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: colors[Random().nextInt(colors.length)],
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Credencial:',
                      style: TextStyle(fontSize: 20,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Usuario:',
                      style: TextStyle(fontSize: 20,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Contraseña:',
                      style: TextStyle(fontSize: 20,),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        credential.name,
                        style: TextStyle(fontSize: 20,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        credential.userName,
                        style: TextStyle(fontSize: 20,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        credential.password,
                        style: TextStyle(fontSize: 20,),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onLongPress: () async {
          //TODO longPress
          //DatabaseService.deleteCredential(credential.id);
        },
        onTap: (){
          //Esta es la forma de pasar argumentos por el constructor hacia otra pagina
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCredential(credential)
            )
          );
        },
      )
    );
  }

}

