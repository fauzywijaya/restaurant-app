import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant/provider/retaurant_list_provider.dart';
import 'package:submission_restaurant/screen/detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:submission_restaurant/screen/widget/alert_widget.dart';
import 'package:submission_restaurant/screen/widget/item_list.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/const.dart';
import 'package:submission_restaurant/shared/theme.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildContent(BuildContext context) {
    Provider.of<RestaurantListProvider>(context, listen: false)
        .fetchRestaurantList();

    return Consumer<RestaurantListProvider>(
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
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello Dicoding",
                            textAlign: TextAlign.left,
                            style: blackTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: medium,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Text(
                            "Lets Find Restaurant",
                            textAlign: TextAlign.left,
                            style: blueTextSyle.copyWith(
                              fontSize: 20.0,
                              fontWeight: bold,
                              letterSpacing: 0.27,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kGrad,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        CupertinoIcons.profile_circled,
                        color: kBlueColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.restaurantList.restaurants.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final response = state.restaurantList.restaurants[index];
                    return ItemList(
                      pictureId: UrlList.smallImageUrl + response.pictureId,
                      name: response.name,
                      city: response.city,
                      rating: response.rating,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: response.id,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
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
