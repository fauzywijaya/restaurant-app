import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant/provider/preference_provider.dart';
import 'package:submission_restaurant/provider/scheduling_provider.dart';
import 'package:submission_restaurant/screen/widget/custom_dialog.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/theme.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "/setting_screen";
  const SettingScreen({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: kGreyColor,
        centerTitle: true,
        title: Text(
          "Setting",
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
          "Setting",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: bold,
          ),
        ),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Dark Theme'),
              trailing: Switch.adaptive(
                value: provider.isDarkTheme,
                onChanged: (value) {
                  provider.enableDarkTheme(value);
                },
              ),
            ),
            ListTile(
              title: const Text('Restaurant Alarm'),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    value: provider.isDailyNewsActive,
                    onChanged: (value) async {
                      if (Platform.isIOS) {
                        customDialog(context);
                      } else {
                        scheduled.scheduledRestaurant(value);
                        provider.enableDailyRestaurant(value);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
