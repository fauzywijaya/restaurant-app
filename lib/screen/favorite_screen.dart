import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant/provider/database_provider.dart';
import 'package:submission_restaurant/screen/widget/alert_widget.dart';
import 'package:submission_restaurant/screen/widget/item_list.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/const.dart';
import 'package:submission_restaurant/shared/theme.dart';

import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = "/favorite_screen";
  const FavoriteScreen({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.HasData) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.result.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final result = provider.result[index];
                    return ItemList(
                      pictureId: UrlList.smallImageUrl + result.pictureId,
                      name: result.name,
                      city: result.city,
                      rating: result.rating,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: result.id,
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
        } else {
          return const AlertWidget(
            animation: 'assets/empty.json',
            text: 'You dont have favorite Restaurant ',
          );
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: kGreyColor,
        centerTitle: true,
        title: Text(
          "Favorite",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Favorite",
          style: blackTextStyle.copyWith(
            fontSize: 22.0,
            fontWeight: bold,
          ),
        ),
      ),
      child: _buildList(context),
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
