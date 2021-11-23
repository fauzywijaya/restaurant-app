import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/remote/api/api_service.dart';
import 'package:submission_restaurant/data/remote/model/restaurant_search.dart';
import 'package:submission_restaurant/shared/const.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  ResponseSearch? _restos;
  int? _founded;
  String _message = '';
  FetchResultState? _state;

  ResponseSearch? get restos => _restos;
  int? get founded => _founded;
  String get error => _message;
  FetchResultState? get state => _state;

  RestaurantSearchProvider({required this.apiService});

  Future<dynamic> fetchRestaurantSearch({String query = ''}) async {
    try {
      _state = FetchResultState.Loading;
      final restos = await apiService.searchRestaurant(query: query);

      if (query.isEmpty) {
        _state = FetchResultState.Searching;
        notifyListeners();
        return _message = 'Searching';
      } else if (restos.founded == 0) {
        _state = FetchResultState.NoData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = FetchResultState.HasData;
        notifyListeners();
        return _restos = restos;
      }
    } on TimeoutException catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'TIMEOUT: $e';
    } on SocketException catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'NO CONNECTION: $e';
    } on Error catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'ERROR: $e';
    }
  }
}
