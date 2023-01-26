import 'package:english_learning/screens/Splash/splash_screen.dart';
import 'package:english_learning/theme/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('system');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: MyColors.greyLightest,
          ),
          scaffoldBackgroundColor: MyColors.greyLightest,
          tabBarTheme: TabBarTheme(
            labelColor: MyColors.purple,
          ),
          appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.black), backgroundColor: Colors.transparent, elevation: 0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: MyColors.purpleLight,
            unselectedItemColor: MyColors.greyLight,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(textStyle: const TextStyle(color: Colors.white)),
          ),
          colorScheme: ColorScheme.light(
              onPrimary: MyColors.purple,
              onBackground: Colors.white,
              onSecondary: MyColors.purpleLight.withOpacity(0.1),
              onSurface: Colors.black.withOpacity(0.1),
              onPrimaryContainer: MyColors.greyLightest,
              onTertiary: MyColors.purpleLight),
          listTileTheme: ListTileThemeData(
            tileColor: Colors.white,
            selectedColor: MyColors.purpleLight,
          )),
      home: SplashScreen(),
    );
  }
}
