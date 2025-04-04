import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(RollMastersApp());
}

class RollMastersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolls Masters',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.text,
          displayColor: AppColors.text,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
