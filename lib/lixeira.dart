import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LixeiraScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lixeira',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, // Tamanho do título
          ),
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF202F58),
      ),
      body: Container(
        color: Color(0xFF202F58), // Cor de fundo para toda a tela
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('lixeira').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao buscar itens da lixeira.'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('A lixeira está vazia.'));
            } else {
              List<Map<String, dynamic>> lixeiraItens = snapshot.data!.docs.map((documentSnapshot) {
                return {...documentSnapshot.data(), 'documentId': documentSnapshot.id};
              }).toList();

              return ListView.builder(
                itemCount: lixeiraItens.length,
                itemBuilder: (context, index) {
                  return _buildTrashItem(context, lixeiraItens[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTrashItem(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: 'Nome do Responsável: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF202F58),
            ),
            children: [
              TextSpan(
                text: item['nomeResponsavel'] ?? 'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF202F58),
                ),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Matrícula: ',
                style: TextStyle(
                  color: Color(0xFF666666),
                ),
                children: [
                  TextSpan(
                    text: item['matricula'] ?? 'N/A',
                    style: TextStyle(
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Órgão: ',
                style: TextStyle(
                  color: Color(0xFF666666),
                ),
                children: [
                  TextSpan(
                    text: item['para'] ?? 'N/A', // Substitua pelo nome do campo correto
                    style: TextStyle(
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _showTrashItemOptions(context, item);
        },
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: Icon(
          Icons.restore,
          color: Color(0xFF43AD59),
        ),
        trailing: Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
      ),
    );
  }

  void _showTrashItemOptions(BuildContext context, Map<String, dynamic> item) {
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
                  _restoreFromTrash(context, item);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF43AD59),
                ),
                child: Text(
                  'Restaurar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteFromTrash(context, item['documentId']);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text(
                  'Excluir Permanentemente',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _restoreFromTrash(BuildContext context, Map<String, dynamic> item) {
    String documentId = item['documentId'];
    FirebaseFirestore.instance.collection('cadastros').doc(documentId).set(item).then((_) {
      FirebaseFirestore.instance.collection('lixeira').doc(documentId).delete().then((_) {
        print('Item restaurado com sucesso');
      }).catchError((error) {
        print('Erro ao excluir item da lixeira: $error');
      });
    }).catchError((error) {
      print('Erro ao restaurar item: $error');
    });
  }

  void _deleteFromTrash(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Permanentemente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Digite a senha de administrador para continuar:'),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String adminPassword = _passwordController.text;
                  if (adminPassword == 'sua_senha_aqui') {
                    Navigator.of(context).pop();
                    _performDeleteFromTrash(documentId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Senha incorreta. Tente novamente.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text(
                  'Confirmar Exclusão',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _performDeleteFromTrash(String documentId) {
    FirebaseFirestore.instance.collection('lixeira').doc(documentId).delete().catchError((error) {
      print('Erro ao excluir permanentemente: $error');
    });
  }
}
