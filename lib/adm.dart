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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset('assets/images/DGFC.png', width: MediaQuery.of(context).size.width * 0.6),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.search, color: Color(0xFF43AD59)),
              title: Text('Pesquisar', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {/* Implementar ação de pesquisa */},
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.filter_list, color: Color(0xFF43AD59)),
              title: Text('Filtrar', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FiltroScreen()));
              },
            ),

            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Color(0xFF43AD59)),
              title: Text('Relatórios', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {
                // Crie uma instância da tela RelatorioScreen e passe a lista de relatórios
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelatorioScreen(
                      relatorios: [], // Passe uma lista vazia ou substitua por uma lista de relatórios se tiver uma
                    ),
                  ),
                );
              },
            ),



            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.dashboard, color: Color(0xFF43AD59)),
              title: Text('Dashboard', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {/* Implementar ação do Dashboard */},
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.delete, color: Color(0xFF43AD59)),
              title: Text('Lixeira', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LixeiraScreen()));
              },
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Sair', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, ${widget.adminName}!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Implementar campos de pesquisa e filtro aqui
          ],
        ),
      ),
    );
  }


} //final