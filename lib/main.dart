import 'package:flutter/material.dart';
import 'package:recetas_app/screens/splash_screen.dart';

void main(){
  runApp(const RecetasApp());
}

class RecetasApp extends StatelessWidget{
  const RecetasApp({super.key});
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Recetas del Mayab",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}