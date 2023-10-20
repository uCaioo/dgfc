import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'login.dart';

class SelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Text(
            'Bem-vindo',
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Color(0xFF202F58),
      ),
      body: _buildContent(context),
      backgroundColor: Color(0xFF202F58),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          SystemNavigator.pop();
        },
        label: Text('Sair'),
        icon: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Layout para tablets e telas largas
          return _buildLargeScreenLayout(context);
        } else {
          // Layout para telas estreitas (como telefones)
          return _buildSmallScreenLayout(context);
        }
      },
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Image.asset(
          'assets/images/Logo_Governo.png',
          width: 280,
          height: 180,
        ),
        SizedBox(height: 20),
        Text(
          'Selecione uma opção',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionCard(
                context,
                'Realizar Cadastro dos Cartões',
                Icons.person,
                Color(0xFF43AD59),
                Colors.white,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildOptionCard(
                context,
                'Entrar como Administrador',
                Icons.admin_panel_settings,
                Color(0xFF43AD59),
                Colors.white,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    // Layout personalizado para telas largas (tablets)
    return Center(
      child: Text(
        'Layout personalizado para telas largas',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
