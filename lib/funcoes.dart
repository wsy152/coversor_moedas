import 'package:flutter/material.dart';

final realController = TextEditingController();
final dollarController = TextEditingController();
final euroController = TextEditingController();

void clearAll() {
  realController.text = "";
  dollarController.text = "";
  euroController.text = "";
}
