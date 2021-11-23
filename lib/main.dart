import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_restaurant/provider/database_provider.dart';
import 'package:submission_restaurant/provider/preference_provider.dart';
import 'package:submission_restaurant/provider/restaurant_detail_provider.dart';
import 'package:submission_restaurant/provider/restaurant_search_provider.dart';
import 'package:submission_restaurant/provider/retaurant_list_provider.dart';
import 'package:submission_restaurant/provider/scheduling_provider.dart';
import 'package:submission_restaurant/screen/detail_screen.dart';
import 'package:submission_restaurant/screen/favorite_screen.dart';
import 'package:submission_restaurant/screen/home_screen.dart';
import 'package:submission_restaurant/screen/main_screen.dart';
import 'package:submission_restaurant/screen/search_screen.dart';
import 'package:submission_restaurant/screen/setting_screen.dart';
import 'package:submission_restaurant/screen/splash_screen.dart';
import 'package:submission_restaurant/shared/navigation.dart';
import 'package:submission_restaurant/utils/background_service.dart';
import 'package:submission_restaurant/utils/notification_helper.dart';
import 'data/local/database_helper.dart';
import 'data/local/preference_helper.dart';
import 'data/remote/api/api_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotications(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantListProvider>(
          create: (_) => RestaurantListProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<RestaurantSearchProvider>(
          create: (_) => RestaurantSearchProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        )
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return MaterialApp(
          title: 'Restaurant ID',
          theme: provider.themeData,
          builder: (context, child) {
            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness:
                    provider.isDarkTheme ? Brightness.dark : Brightness.light,
              ),
              child: Material(
                child: child,
              ),
            );
          },
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(),
            MainScreen.routeName: (context) => const MainScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            DetailScreen.routeName: (context) => DetailScreen(
                  id: ModalRoute.of(context)?.settings.arguments as String,
                ),
            SearchScreen.routeName: (context) => const SearchScreen(),
            SettingScreen.routeName: (context) => const SettingScreen(),
            FavoriteScreen.routeName: (context) => const FavoriteScreen()
          },
        );
      }),
    );
  }
}
