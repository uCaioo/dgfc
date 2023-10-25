import 'package:flutter/material.dart';

class NotificacoesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF202F58), // Define a cor da AppBar
      ),
      backgroundColor: Color(0xFF202F58), // Define a cor de fundo
      body: Center(
        child: Text(
          'Página de Notificações (em desenvolvimento)',
          style: TextStyle(color: Colors.white), // Define a cor do texto como branco
        ),
      ),
    );
  }
}
