
import 'package:flutter/foundation.dart';

class NavMenuProvider extends ChangeNotifier{
  int _currentIndex = 0; // home is default


  get currentIndex => _currentIndex;
  set currentIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentIndex(int index){
    this._currentIndex = index;
    notifyListeners();
  }

}