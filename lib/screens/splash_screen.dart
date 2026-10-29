import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recetas_app/screens/home_screen.dart';

class SplashScreen  extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>_SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2200),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> const HomeScreen()),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 127, 1, 133),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, color: Colors.white,size: 90,),
          SizedBox(height: 16,),
          Text("Recetas App", style: TextStyle(color: Colors.white, fontSize: 28),),
          SizedBox(height: 24,),
          CircularProgressIndicator(color: Colors.white,)
        ],
      ),
    );
  }
}