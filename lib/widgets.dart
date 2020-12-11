import 'package:flutter/material.dart';

Widget bildTextField(
    String text, String prefix, TextEditingController ctl, Function f) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: ctl,
    onChanged: f,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      fontSize: 25,
      color: Colors.blue,
    ),
  );
}
