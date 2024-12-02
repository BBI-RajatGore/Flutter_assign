
import 'package:flutter/material.dart';


class MyCounter with ChangeNotifier {

  int _counter = 0;

  getCounter() => _counter;

  void  resetCounter() {
    _counter = 0;
    notifyListeners();
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if(_counter<=0){
      return ;
    }
    _counter--;
    notifyListeners();
  }
}