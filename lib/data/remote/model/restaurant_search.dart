import 'dart:convert';

class ResponseSearch {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  ResponseSearch(
      {required this.error, required this.founded, required this.restaurants});

  factory ResponseSearch.fromJson(Map<String, dynamic> json) => ResponseSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
          json["restaurants"].map(
            (x) => Restaurant.fromJsonList(x),
          ),
        ),
      );
  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurant {
  String id;
  String name;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJsonList(Map<String, dynamic> json) => Restaurant(
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
