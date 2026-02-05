import 'package:flutter/material.dart';
import 'package:lekhk/models/blogItemModel.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
ThemeMode _mode = ThemeMode.light;
ThemeMode get mode=>_mode;

  void setTheme(ThemeMode modeType) {
    _mode=modeType;
    notifyListeners();
  }
}