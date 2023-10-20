import 'package:flutter/material.dart';
import 'filtro.dart';
import 'lixeira.dart';
import 'relatorio.dart';
import 'login.dart';

class AdmScreen extends StatefulWidget {
  final String adminName;
  AdmScreen({required this.adminName});

  @override
  _AdmScreenState createState() => _AdmScreenState();
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
                  _buildCard('Avisos', Icons.warning, () {
                    /* Implementar ação de pesquisa */
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
                    /* Implementar ação do Dashboard */
                  }),
                  _buildCard('Lixeira', Icons.delete, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LixeiraScreen()));
                  }),
                  _buildCard('Sair', Icons.logout, () {
                    _logout(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Function() onTap) {
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
                  color: Color(0xFF43AD59),
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
