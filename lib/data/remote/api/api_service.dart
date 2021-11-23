import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:submission_restaurant/data/remote/model/restaurant.dart';
import 'package:submission_restaurant/data/remote/model/restaurant_detail.dart';
import 'package:submission_restaurant/data/remote/model/restaurant_search.dart';
import 'package:submission_restaurant/shared/const.dart';

class ApiService {
  Future<ResponseList> getRestaurantList(http.Client client) async {
    final response = await client.get(
      Uri.parse(
        '${UrlList.baseUrl}${UrlList.restaurantList}',
      ),
    );

    if (response.statusCode == 200) {
      return ResponseList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to Load Restaurant List!");
    }
  }

  Future<ResponseDetail> getRestaurantDetail({required String id}) async {
    final response = await http.get(
      Uri.parse(
        '${UrlList.baseUrl}${UrlList.restaurantDetail}$id',
      ),
    );

    if (response.statusCode == 200) {
      return ResponseDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to Load Detail Restaurant");
    }
  }

  Future<ResponseSearch> searchRestaurant({required String query}) async {
    final response = await http.get(
      Uri.parse(
        '${UrlList.baseUrl}${UrlList.searchRestaurant}?q=$query',
      ),
    );

    if (response.statusCode == 200) {
      return ResponseSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load search result!');
    }
  }
}
