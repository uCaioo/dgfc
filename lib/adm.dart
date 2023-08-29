import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'relatorio.dart';
import 'lixeira.dart';



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
              onTap: () {/* Implementar ação de filtro */},
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Color(0xFF43AD59)),
              title: Text('Relatórios', style: TextStyle(color: Color(0xFF202F58))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RelatorioScreen()));
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



  void _navigateToTrash() {
    _showTrash();
  }

  void _showTrash() {
    FirebaseFirestore.instance.collection('lixeira').get().then((querySnapshot) {
      List<Map<String, dynamic>> lixeiraItens = querySnapshot.docs.map((documentSnapshot) {
        return {...documentSnapshot.data(), 'documentId': documentSnapshot.id};
      }).toList();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lixeira'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: lixeiraItens.length,
                itemBuilder: (context, index) {
                  return _buildTrashItem(lixeiraItens[index]);
                },
              ),
            ),
          );
        },
      );
    }).catchError((error) {
      print('Erro ao buscar itens da lixeira: $error');
    });
  }

  Widget _buildTrashItem(Map<String, dynamic> item) {
    return ListTile(
      title: Text('Nome do Responsável: ${item['nomeResponsavel'] ?? 'N/A'}'),
      subtitle: Text('Matrícula: ${item['matricula'] ?? 'N/A'}'),
      onTap: () {
        _showTrashItemOptions(item);
      },
    );
  }

  void _showTrashItemOptions(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opções do Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  _restoreFromTrash(item);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF43AD59), // Define a cor de fundo como #43AD59
                ),
                child: Text('Restaurar'),
              ),

              ElevatedButton(
                onPressed: () {
                  _deleteFromTrash(item['documentId']);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Define a cor de fundo como vermelho
                ),
                child: Text('Excluir Permanentemente'),
              ),

            ],
          ),
        );
      },
    );
  }

  void _restoreFromTrash(Map<String, dynamic> item) {
    String documentId = item['documentId']; // Obtém o ID do documento original

    // Passo 1: Adicionar o item de volta à coleção 'cadastros' usando o mesmo ID
    FirebaseFirestore.instance.collection('cadastros').doc(documentId).set(item).then((_) {
      // Passo 2: Excluir o item da lixeira usando o mesmo ID
      FirebaseFirestore.instance.collection('lixeira').doc(documentId).delete().then((_) {
        // Atualizar a interface ou qualquer outra ação necessária após a restauração
        print('Item restaurado com sucesso');
      }).catchError((error) {
        print('Erro ao excluir item da lixeira: $error');
      });
    }).catchError((error) {
      print('Erro ao restaurar item: $error');
    });
  }



  void _deleteFromTrash(String documentId) {
    FirebaseFirestore.instance.collection('lixeira').doc(documentId).delete().catchError((error) {
      print('Erro ao excluir permanentemente: $error');
    });
  }

}