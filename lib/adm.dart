import 'package:flutter/material.dart';
import 'filtro.dart';
import 'lixeira.dart';
import 'relatorio.dart';
import 'login.dart';
import 'notificacoes.dart';
import 'dashboard.dart';

class AdmScreen extends StatefulWidget {

  final String adminName;

  AdmScreen({required this.adminName});

  @override
  _AdmScreenState createState() => _AdmScreenState ();
}

class _AdmScreenState extends State<AdmScreen> {
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel de Administração'),
        backgroundColor: Color(0xFF202F58),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF202F58),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seja bem-vindo!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                children: [
                  _buildCard('Notificações', Icons.message, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacoesScreen()));
                  }),
                  _buildCard('Pesquisar', Icons.search, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FiltroScreen()));
                  }),
                  _buildCard('Relatórios', Icons.bar_chart, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RelatorioScreen(
                          relatorios: [],
                        ),
                      ),
                    );
                  }),
                  _buildCard('Dashboard', Icons.dashboard, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                  }),
                  _buildCard('Lixeira', Icons.delete, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LixeiraScreen()));
                  }),
                  _buildCard('Sair', Icons.logout, () {
                    _logout(context);
                  }, Colors.red), // Ícone vermelho
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Function() onTap, [Color? iconColor]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color(0xFFffffff),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? Color(0xFF43AD59), // Cor padrão ou a cor passada como argumento
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF43AD59),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}