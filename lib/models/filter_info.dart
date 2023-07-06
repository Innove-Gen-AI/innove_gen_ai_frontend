
// ignore: constant_identifier_names
import 'package:flutter/cupertino.dart';

enum FilterOptions { Positive, Negative, Recent, Sponsored }

class FilterInfo extends ChangeNotifier {

  late List<FilterOptions> _filters = [FilterOptions.Positive,FilterOptions.Negative,FilterOptions.Recent,FilterOptions.Sponsored];

  List<FilterOptions> get getFilterOptions => _filters;

  void updateFilters(List<FilterOptions> options){
    _filters = options;
    notifyListeners();
  }

  void clearFilters(List<String> options){
    _filters = List.empty();
    notifyListeners();
  }

}
