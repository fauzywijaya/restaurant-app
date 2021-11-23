import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant/data/remote/model/restaurant.dart';
import 'package:submission_restaurant/provider/database_provider.dart';
import 'package:submission_restaurant/screen/favorite_screen.dart';
import 'package:submission_restaurant/shared/theme.dart';

class FavoriteButton extends StatelessWidget {
  final Restaurants favorite;

  const FavoriteButton({required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(favorite.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return isFavorite
                ? InkWell(
                    onTap: () {
                      provider.removeRestaurant(favorite.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kBlueColor,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      provider.addRestaurant(favorite);
                      showActionSnackBar(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kBlueColor,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}

void showActionSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      'Berhasil ditambahkan ke daftar favorit',
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: kWhiteColor,
          ),
    ),
    backgroundColor: kGrad,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Lihat',
      textColor: kBlackPrimary,
      onPressed: () {
        Navigator.pushNamed(
          context,
          FavoriteScreen.routeName,
        );
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
