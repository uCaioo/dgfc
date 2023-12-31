import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF202F58), // Define a cor da AppBar
      ),
      backgroundColor: Color(0xFF202F58), // Define a cor de fundo
      body: Center(
        child: Text(
          'Página do Dashboard (em desenvolvimento)',
          style: TextStyle(color: Colors.white), // Define a cor do texto como branco
        ),
      ),
    );
  }
}
