import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'relatorio.dart';
import 'lixeira.dart';
import 'dashboard.dart';
import 'filtro.dart';



class AdmScreen extends StatefulWidget {
  final String adminName;
  AdmScreen({required this.adminName});

  @override
  _AdmScreenState createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {
  void _logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
        color: Color(0xFF202F58), // Cor de fundo da tela
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seja bem-vindo!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              children: [
                _buildCard('Pesquisar', Icons.search, () {
                  /* Implementar ação de pesquisa */
                }),
                _buildCard('Filtrar', Icons.filter_list, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FiltroScreen()));
                }),
                _buildCard('Relatórios', Icons.bar_chart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RelatorioScreen(
                        relatorios: [], // Passe uma lista vazia ou substitua por uma lista de relatórios se tiver uma
                      ),
                    ),
                  );
                }),
                _buildCard('Dashboard', Icons.dashboard, () {
                  /* Implementar ação do Dashboard */
                }),
                _buildCard('Lixeira', Icons.delete, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LixeiraScreen()));
                }),
                _buildCard('Sair', Icons.logout, () {
                  _logout(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Color(0xFF43AD59),
                size: 30,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(color: Color(0xFF43AD59)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 //final