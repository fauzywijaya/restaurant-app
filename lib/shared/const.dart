enum FetchResultState { Loading, Searching, NoData, HasData, Failure }

enum PostResultState { Idle, Loading, Success, Failure }

enum ResultState { Loading, NoData, HasData, Error }

class UrlList {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String smallImageUrl =
      'https://restaurant-api.dicoding.dev/images/small/';
  static const String largeImageUrl =
      'https://restaurant-api.dicoding.dev/images/large/';
  static const String restaurantList = '/list';
  static const String restaurantDetail = '/detail/';
  static const String searchRestaurant = '/search';
  static const String restaurantReview = '/review';
}
