import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/IconsProvider.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Acerca de'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          //Contactos
          Column(
            children: <Widget>[
              Text('Contactenos'),
              SvgPicture.asset(mailIcon),
            ],
          ),

          //Donaciones
          Column(
            children: <Widget>[
              Text('Comprame un cafe'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: SvgPicture.asset(phoneIcon),
                      ),
                      Text('Saldo')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: SvgPicture.asset(enzonaIcon),
                      ),
                      Text('EnZona')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: SvgPicture.asset(bitCoinIcon),
                      ),
                      Text('BitCoin')
                    ],
                  )
                ],
              )
            ],
          ),

          //Politica de privacidad y terminos de uso
          Text('Politica de privacidad y terminos de uso'),
          Text('Creditos'),
          //TODO Hacer la version dinamica
          Text('Version 1.0'),
          Text('@ Copyrigth 2020 JustAnotherCoder'),
        ],
      )
    );
  }
}