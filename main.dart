    import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
    import 'package:rice/app_theme.dart';
import 'package:rice/firebase_options.dart';
 
    void main() async {

      await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
);
      runApp(FriedRiceApp());
    }

    class FriedRiceApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Fried Rice Maker',
          theme: AppTheme.lightTheme,
          home: HomeScreen(),
        );
      }
    }

    class AppTheme {
      static var lightTheme;
    }