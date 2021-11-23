import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:submission_restaurant/data/remote/model/restaurant_detail.dart';
import 'package:submission_restaurant/data/remote/model/restaurant.dart';
import 'package:submission_restaurant/provider/database_provider.dart';
import 'package:submission_restaurant/provider/restaurant_detail_provider.dart';
import 'package:submission_restaurant/screen/widget/alert_widget.dart';
import 'package:submission_restaurant/screen/widget/favorite_button.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/const.dart';
import 'package:submission_restaurant/shared/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = "/detail_screen";
  final String id;
  const DetailScreen({required this.id});

  Widget _buildContent(BuildContext context) {
    // final provider = Provider.of<DatabaseProvider>(context);
    Provider.of<RestaurantDetailProvider>(
      context,
      listen: false,
    ).fetchRestaurantDetail(id);
    return Consumer<RestaurantDetailProvider>(
      builder: (context, state, _) {
        if (state.state == FetchResultState.Loading) {
          return Center(
            child: Lottie.asset(
              'assets/loading.json',
              width: 180.0,
              height: 180.0,
            ),
          );
        } else if (state.state == FetchResultState.HasData) {
          final response = state.reponseDetail.restaurant;
          final responseFavorite = Restaurants(
            id: response.id,
            name: response.name,
            pictureId: response.pictureId,
            city: response.city,
            rating: response.rating,
          );
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.amber.shade900,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${UrlList.largeImageUrl}${response.pictureId}',
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 24),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kBlueColor,
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                child: const Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            FavoriteButton(favorite: responseFavorite)
                          ]),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              response.name,
                              style: blueTextSyle.copyWith(
                                  fontSize: 24, fontWeight: bold),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var category in response.categories)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[50],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      category.name!,
                                      style: greyTextStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: medium,
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Text(
                                      '${response.rating} / 5.0',
                                      style: greyTextStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    RatingBar.builder(
                                      initialRating: response.rating,
                                      allowHalfRating: true,
                                      ignoreGestures: true,
                                      minRating: 1,
                                      maxRating: 5,
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 24,
                                  color: kLightGreyColor,
                                ),
                                Text('${response.address}, ${response.city}',
                                    style: lightGreyTextStyle.copyWith(
                                        fontSize: 18, fontWeight: bold))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deskripsi",
                                  style: blueTextSyle.copyWith(
                                    fontSize: 20.0,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                ReadMoreText(
                                  response.description,
                                  trimLines: 2,
                                  textAlign: TextAlign.justify,
                                  style: lightGreyTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: regular,
                                  ),
                                  trimCollapsedText: 'Lihat Semua',
                                  trimExpandedText: 'Lihat Sebagian',
                                  moreStyle: yellowTextStyle.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: medium,
                                  ),
                                  lessStyle: yellowTextStyle.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: medium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Menus",
                              style: blueTextSyle.copyWith(
                                  fontSize: 20, fontWeight: bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildMenuListWidget(
                              label: 'Foods',
                              icon: const Icon(
                                Icons.lunch_dining_rounded,
                                color: kGreyColor,
                              ),
                              menus: response.menus.foods,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildMenuListWidget(
                              label: 'Drinks',
                              icon: const Icon(
                                Icons.local_cafe_outlined,
                                color: kGreyColor,
                              ),
                              menus: response.menus.drinks,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildReviewWidget(
                              context: context,
                              reviews: response.customerReviews,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state.state == FetchResultState.NoData) {
          return const AlertWidget(
            animation: 'assets/empty.json',
            text: 'Restaurant Not Found',
          );
        } else if (state.state == FetchResultState.Failure) {
          return const AlertWidget(
            animation: 'assets/no-connection.json',
            text: 'Opps, Something Wrong. Please Check Your Connection',
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildReviewWidget({
    required BuildContext context,
    required List<CustomerReview> reviews,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apa Kata Mereka',
            style: blueTextSyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              top: 8.0,
            ),
            child: Column(
              children: [
                for (var review in reviews)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 64.0,
                            width: 56.0,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: kGreyColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.name,
                                style: lightGreyTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                ),
                              ),
                              Text(
                                review.date,
                                style: lightGreyTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                ),
                              ),
                              Text(
                                review.review,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: lightGreyTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildMenuListWidget({
    required String label,
    required Icon icon,
    required List<Category> menus,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: blueTextSyle.copyWith(
              fontSize: 18.0,
              fontWeight: medium,
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            children: [
              for (var item in menus)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 48.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: icon,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        item.name!,
                        style: lightGreyTextStyle.copyWith(
                          fontSize: 16.0,
                          fontWeight: regular,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: _buildContent(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
