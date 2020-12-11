import 'package:conversor_moedas/funcoes.dart';
import 'package:conversor_moedas/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=424e3f5d';
void main() async {
  print(await getData());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.black,
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar;
  double euro;
  void realChange(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }

    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsPrecision(6);
    euroController.text = (real / euro).toString();
  }

  void dollarChange(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsPrecision(3);
    euroController.text = (dollar * this.dollar / euro).toStringAsPrecision(3);
  }

  void euroChange(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsPrecision(3);
    dollarController.text = (euro * this.euro / dollar).toStringAsPrecision(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\$ Conversor de Moedas \$',
          style: TextStyle(color: Colors.blue, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando dados...',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Contem erros na chamada...',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dollar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 120,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField('Reais', 'R\$', realController, realChange),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField(
                          'Dolar', '\$', dollarController, dollarChange),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField('Euro ', '\€', euroController, euroChange),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
