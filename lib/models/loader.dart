import 'package:flutter/foundation.dart';

class Loader extends ChangeNotifier{

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loadingStatus) {
    _isLoading = loadingStatus;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }





}

