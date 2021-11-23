import 'dart:convert';

// ResponseList restaurantFromJsonList(String str) =>
//     ResponseList.fromJsonList(json.decode(str));

class ResponseList {
  bool error;
  String message;
  int count;
  List<Restaurants> restaurants;
  ResponseList(
      {required this.error,
      required this.message,
      required this.count,
      required this.restaurants});

  factory ResponseList.fromJson(Map<String, dynamic> json) => ResponseList(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurants>.from(
          (json["restaurants"] as List).map(
            (x) => Restaurants.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurants {
  String id;
  String name;
  String pictureId;
  String city;
  double rating;

  Restaurants({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        id: json["id"].toString(),
        name: json["name"].toString(),
        pictureId: json["pictureId"].toString(),
        city: json["city"].toString(),
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}

List<Restaurants> parseRestaurant(String? json) {
  if (json == null) {
    return [];
  }

  final List parsed = jsonDecode(json)["restaurants"];
  return parsed.map((json) => Restaurants.fromJson(json)).toList();
}
