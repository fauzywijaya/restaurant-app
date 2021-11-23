import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/remote/api/api_service.dart';
import 'package:submission_restaurant/data/remote/model/restaurant.dart';
import 'package:submission_restaurant/shared/const.dart';
import 'package:http/http.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  late ResponseList _responseList;
  String _message = '';
  late FetchResultState _state;

  ResponseList get restaurantList => _responseList;
  String get message => _message;
  FetchResultState get state => _state;

  RestaurantListProvider({required this.apiService});

  Future<dynamic> fetchRestaurantList() async {
    try {
      _state = FetchResultState.Loading;
      final responseList = await apiService.getRestaurantList(Client());
      if (responseList.count == 0) {
        _state = FetchResultState.NoData;
        notifyListeners();
        return _message = 'No Data Availble';
      } else {
        _state = FetchResultState.HasData;
        notifyListeners();
        return _responseList = responseList;
      }
    } on TimeoutException catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'Timeout: $e';
    } on SocketException catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'No Connection: $e';
    } on Error catch (e) {
      _state = FetchResultState.Failure;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
