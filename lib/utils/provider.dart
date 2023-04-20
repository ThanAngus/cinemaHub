import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuProvider = StateNotifierProvider((ref) {
  return MenuController();
});

final changeThemeProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    return ThemeState();
  },
);

class MenuController extends StateNotifier {
  MenuController() : super([]);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}

class ThemeState extends ChangeNotifier {
  bool darkMode = false;

  void enabledDarkMode() {
    darkMode = true;
    notifyListeners();
  }

  void enabledLightMode() {
    darkMode = false;
    notifyListeners();
  }
}
