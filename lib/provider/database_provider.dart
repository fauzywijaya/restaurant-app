import 'package:flutter/foundation.dart';
import 'package:submission_restaurant/data/local/database_helper.dart';
import 'package:submission_restaurant/data/remote/model/restaurant.dart';
import 'package:submission_restaurant/shared/const.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurants> _result = [];
  List<Restaurants> get result => _result;

  DatabaseProvider({required this.databaseHelper}) {
    getRestaurant();
  }

  void getRestaurant() async {
    _result = await databaseHelper.getRestaurants();

    if (_result.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addRestaurant(Restaurants restaurant) async {
    try {
      await databaseHelper.insertRestaurant(restaurant);
      getRestaurant();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoriteRestaurant = await databaseHelper.getRestauranyById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeRestaurant(String id) async {
    try {
      await databaseHelper.deleteRestaurantById(id);
      getRestaurant();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
