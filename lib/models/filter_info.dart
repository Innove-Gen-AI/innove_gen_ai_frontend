
// ignore: constant_identifier_names
import 'package:flutter/cupertino.dart';

enum FilterOptions { Positive, Negative, Recent }


class FilterInfo extends ChangeNotifier {

  late List<String> _filters = [];

  List<String> get getFilterOptions => _filters;

  void updateFilters(List<String> options){
    _filters = options;
    notifyListeners();
  }

  void clearFilters(List<String> options){
    _filters = List.empty();
    notifyListeners();
  }

}
