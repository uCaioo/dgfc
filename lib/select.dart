import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importe o pacote flutter/services
import 'welcome_screen.dart'; // Importe aqui a tela de boas-vindas (welcome_screen.dart)
import 'login.dart'; // Importe aqui a tela de login (login.dart)

class SelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity, // Define a largura máxima para ocupar todo o espaço disponível
          child: Text(
            'Bem-vindo',
            textAlign: TextAlign.center, // Centraliza o texto
          ),
        ),
        backgroundColor: Color(0xFF202F58), // Define a cor de fundo da barra de navegação
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Adiciona um espaço acima da imagem
          Image.asset(
            'assets/images/Logo_Governo.png',
            width: 280,
            height: 180,
          ),
          SizedBox(height: 20), // Adiciona um espaço entre a imagem e o texto
          Text(
            'Selecione uma opção',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20), // Adiciona um espaço entre o texto e as opções
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionCard(
                  context,
                  'Realizar cadastro dos cartões', // Corrigido para "Realizar Cadastro"
                  Icons.person, // Ícone de usuário padrão do Flutter
                  Color(0xFF43AD59), // Define a cor de fundo do card
                  Colors.white, // Define a cor do texto
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
                SizedBox(height: 20), // Adiciona um espaço entre os cards
                _buildOptionCard(
                  context,
                  'Entrar como administrador',
                  Icons.admin_panel_settings, // Ícone de administrador padrão do Flutter
                  Color(0xFF43AD59), // Define a cor de fundo do card
                  Colors.white, // Define a cor do texto
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), // Abre a tela de login
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF202F58), // Define a cor de fundo da tela como #202F58
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Lógica para sair do app
          SystemNavigator.pop(); // Chama o método pop para fechar o aplicativo
        },
        label: Text('Sair'),
        icon: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red, // Define a cor de fundo do botão
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData iconData, Color cardColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                iconData,
                size: 80,
                color: textColor,
              ), // Ícone
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
              ), // Texto
            ],
          ),
        ),
      ),
    );
  }
}
