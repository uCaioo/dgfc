import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'select.dart'; // Importe a tela SelectScreen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navega para SelectScreen após 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo_Sead.png', width: 150),
            SizedBox(height: 20),
            SpinKitWave(
              color: Color(0xFF43AD59),
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }

} //final
