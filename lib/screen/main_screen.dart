import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_restaurant/screen/detail_screen.dart';
import 'package:submission_restaurant/screen/favorite_screen.dart';
import 'package:submission_restaurant/screen/home_screen.dart';
import 'package:submission_restaurant/screen/search_screen.dart';
import 'package:submission_restaurant/screen/setting_screen.dart';
import 'package:submission_restaurant/screen/widget/platform_widget.dart';
import 'package:submission_restaurant/shared/theme.dart';
import 'package:submission_restaurant/utils/notification_helper.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const SettingScreen()
  ];
  final NotificationHelper _notificationHelper = NotificationHelper();

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  final _items = <Widget>[
    const Icon(
      Icons.home_rounded,
      size: 30,
    ),
    const Icon(
      Icons.search_rounded,
      size: 30,
    ),
    const Icon(
      Icons.favorite_rounded,
      size: 30,
    ),
    const Icon(
      Icons.settings_rounded,
      size: 30,
    ),
  ];

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: kWhiteColor),
        ),
        child: CurvedNavigationBar(
          color: kBlueColor,
          buttonBackgroundColor: kBlueColor,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          height: 60,
          items: _items,
          index: _bottomNavIndex,
          onTap: _onBottomNavTapped,
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Container(
      color: kBlueColor,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          child: Scaffold(
            extendBody: true,
            body: _listWidget[_bottomNavIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: kWhiteColor),
              ),
              child: CurvedNavigationBar(
                color: kBlueColor,
                buttonBackgroundColor: kGrad,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOutCirc,
                animationDuration: const Duration(milliseconds: 200),
                height: 60,
                items: _items,
                index: _bottomNavIndex,
                onTap: _onBottomNavTapped,
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
