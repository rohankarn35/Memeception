import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_meme_generator/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: 
      Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image.asset("assets/meme.png",),
          const Text("Memeception",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 35),)
        ],
      )
      ),
    );
  }
}