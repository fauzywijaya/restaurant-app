import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:submission_restaurant/shared/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemList extends StatelessWidget {
  final String pictureId;
  final String name;
  final String city;
  final double rating;
  final Function() onPressed;

  const ItemList(
      {required this.pictureId,
      required this.name,
      required this.city,
      required this.rating,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: kGrad,
        shadowColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: pictureId,
                    height: 72.0,
                    width: 72.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: blackTextStyle.copyWith(
                            fontSize: 18.0,
                            fontWeight: bold,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        city,
                        style: blackTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: regular,
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            rating.toString(),
                            style: blackTextStyle.copyWith(
                                fontSize: 14.0,
                                fontWeight: medium,
                                decoration: TextDecoration.none),
                          ),
                          const SizedBox(width: 8.0),
                          RatingBar.builder(
                            initialRating: rating,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            minRating: 1,
                            maxRating: 5,
                            itemCount: 5,
                            itemSize: 14.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kYellowColor,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
