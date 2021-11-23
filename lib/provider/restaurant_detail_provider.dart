import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/remote/api/api_service.dart';
import 'package:submission_restaurant/data/remote/model/restaurant_detail.dart';

import 'package:submission_restaurant/shared/const.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  late ResponseDetail _responseDetail;
  String _message = '';
  late FetchResultState _state;

  ResponseDetail get reponseDetail => _responseDetail;
  String get message => _message;
  FetchResultState get state => _state;

  RestaurantDetailProvider({required this.apiService});

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = FetchResultState.Loading;
      final detail = await apiService.getRestaurantDetail(id: id);
      if (detail.restaurant == null) {
        _state = FetchResultState.NoData;
        notifyListeners();
        return _message = detail.message;
      } else {
        _state = FetchResultState.HasData;
        notifyListeners();
        return _responseDetail = detail;
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
