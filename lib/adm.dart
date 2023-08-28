import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/services.dart';



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
                _showReports();
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
                _navigateToTrash();
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

  void _showReports() {
    FirebaseFirestore.instance.collection('cadastros').get().then((querySnapshot) {
      List<Map<String, dynamic>> cadastros = querySnapshot.docs.map((documentSnapshot) {
        return {...documentSnapshot.data(), 'documentId': documentSnapshot.id};
      }).toList();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Relatórios'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: cadastros.length,
                itemBuilder: (context, index) {
                  return _buildReportEntry(cadastros[index]);
                },
              ),
            ),
          );
        },
      );
    }).catchError((error) {
      print('Erro ao buscar relatórios: $error');
    });
  }

  Widget _buildReportEntry(Map<String, dynamic> cadastro) {
    return ListTile(
      title: Text('Nome do Responsável: ${cadastro['nomeResponsavel'] ?? 'N/A'}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orgão: ${cadastro['para'] ?? 'N/A'}'),
          Text('Matrícula: ${cadastro['matricula'] ?? 'N/A'}'),
        ],
      ),
      onTap: () {
        _showDetailsFromReport(cadastro);
      },
    );
  }

  void _showDetailsFromReport(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes do Registro'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/Sead_Sup.png'),
                SizedBox(height: 16),
                _buildDetailRow('Emissor', data['emissor']),
                _buildDetailRow('Para', data['para']),
                _buildDetailRow('Unidade Recebedora', data['unidadeRecebedora']),
                _buildDetailRow('Cidade', data['cidade']),
                _buildDetailRow('Nome do Responsável', data['nomeResponsavel']),
                _buildDetailRow('Matrícula', data['matricula']),
                SizedBox(height: 16),
                _buildSignatureImage('Assinatura Responsável', data['assinaturaResponsavel']),
                _buildSignatureImage('Assinatura Fiscal', data['assinaturaFiscal']),
                if (data['veiculos'] != null) ..._buildVeiculos(data['veiculos']),
                SizedBox(height: 16),
                Image.asset('assets/images/Sead_inf.png'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _deleteReport(data['documentId']);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Define a cor de fundo como vermelho
                  ),
                  child: Text('Excluir Relatório', style: TextStyle(color: Colors.white)),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar', style: TextStyle(color: Colors.red)),
            ),

            TextButton(
              onPressed: null, // Nenhuma função associada
              child: Text('Visualizar PDF', style: TextStyle(color: Color(0xFF43AD59))),
            ),

          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureImage(String title, String? imageUrl) {
    if (imageUrl == null) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(imageUrl, width: 150, height: 100),
        ),
      ],
    );
  }

  List<Widget> _buildVeiculos(List<dynamic>? veiculos) {
    if (veiculos == null || veiculos.isEmpty) {
      return [];
    }
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Veículos:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: veiculos.map<Widget>((veiculo) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVeiculoDetail('Combustível', veiculo['combustivel']),
                _buildVeiculoDetail('Cota', veiculo['cota']),
                _buildVeiculoDetail('Modelo', veiculo['modelo']),
                _buildVeiculoDetail('Placa', veiculo['placa']),
                _buildVeiculoDetail('Documento', veiculo['documento']),
              ],
            ),
          );
        }).toList(),
      ),
    ];
  }

  Widget _buildVeiculoDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value ?? 'N/A', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _deleteReport(String documentId) {
    FirebaseFirestore.instance.collection('cadastros').doc(documentId).get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        FirebaseFirestore.instance.collection('lixeira').add(data);
        FirebaseFirestore.instance.collection('cadastros').doc(documentId).delete();
      }
    });
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