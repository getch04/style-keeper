import 'package:flutter/material.dart';

class SelectedSampleProvider extends ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void clear() {
    _selectedIndex = 1;
    notifyListeners();
  }
}
