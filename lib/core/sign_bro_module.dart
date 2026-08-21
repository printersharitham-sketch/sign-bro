import 'package:flutter/material.dart';

abstract class SignBroModule {
  String get id;
  String get title;
  String get description;
  IconData get icon;

  Widget buildPage();
}
