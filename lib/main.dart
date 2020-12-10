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
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\$ Conversor de Moedas \$',
          style: TextStyle(color: Colors.yellow, fontSize: 25),
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
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 120,
                        color: Colors.amber,
                      ),
                      TextField(
                          decoration: InputDecoration(
                            labelText: 'Reais',
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: 'R\$',
                          ),
                          style: TextStyle(fontSize: 25, color: Colors.yellow))
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
