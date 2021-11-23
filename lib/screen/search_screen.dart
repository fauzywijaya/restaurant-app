import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant/provider/restaurant_search_provider.dart';
import 'package:submission_restaurant/screen/detail_screen.dart';
import 'package:submission_restaurant/screen/widget/alert_widget.dart';
import 'package:submission_restaurant/screen/widget/item_list.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/const.dart';
import 'package:submission_restaurant/shared/theme.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _buildContent(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    Provider.of<RestaurantSearchProvider>(
      context,
      listen: false,
    ).fetchRestaurantSearch();
    return Column(
      children: [
        Consumer<RestaurantSearchProvider>(
          builder: (context, state, _) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Melting.....',
                  contentPadding: const EdgeInsets.all(10.0),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            state.fetchRestaurantSearch(query: '');
                          },
                          child: const Icon(
                            Icons.close,
                          ),
                        )
                      : null,
                ),
                onChanged: (query) {
                  state.fetchRestaurantSearch(query: query);
                },
              ),
            );
          },
        ),
        Expanded(
          flex: 8,
          child: Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) {
              if (state.state == FetchResultState.Loading) {
                return const AlertWidget(
                  animation: 'assets/search.json',
                  text: 'Let Find Restaurant',
                );
              } else if (state.state == FetchResultState.Searching) {
                return const AlertWidget(
                  animation: 'assets/loading.json',
                  text: 'Finding Restaurant',
                );
              } else if (state.state == FetchResultState.HasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.restos!.restaurants.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    var restaurant = state.restos!.restaurants[index];
                    return ItemList(
                      pictureId: UrlList.smallImageUrl + restaurant.pictureId,
                      name: restaurant.name,
                      city: restaurant.city,
                      rating: restaurant.rating,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: restaurant.id,
                        );
                      },
                    );
                  },
                );
              } else if (state.state == FetchResultState.NoData) {
                return const AlertWidget(
                  animation: 'assets/empty.json',
                  text: 'Oops! The Restaurant is not Available',
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
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _buildContent(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Search",
          style: blackTextStyle.copyWith(
            fontSize: 22.0,
            fontWeight: bold,
          ),
        ),
      ),
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
