import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:submission_restaurant/shared/theme.dart';

class AlertWidget extends StatelessWidget {
  final String animation;
  final String text;
  final Widget? action;

  const AlertWidget({
    required this.animation,
    required this.text,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: 180.0, height: 180.0),
          SizedBox(
            width: 200.0,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: greyTextStyle.copyWith(fontSize: 18.0, fontWeight: bold),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          action != null ? action! : const SizedBox()
        ],
      ),
    );
  }
}
