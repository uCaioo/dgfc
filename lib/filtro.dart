import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FiltroScreen extends StatefulWidget {
  @override
  _FiltroScreenState createState() => _FiltroScreenState();
}

class _FiltroScreenState extends State<FiltroScreen> {
  final TextEditingController filtroController = TextEditingController();
  List<Map<String, dynamic>> filteredReports = [];
  bool isLoading = false;

  void _showFilteredReports(BuildContext context) {
    final String filtro = filtroController.text.toLowerCase();

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection('cadastros').get().then((querySnapshot) {
      List<Map<String, dynamic>> cadastros = querySnapshot.docs.map((documentSnapshot) {
        return {...documentSnapshot.data(), 'documentId': documentSnapshot.id};
      }).toList();

      List<Map<String, dynamic>> filteredCadastros = cadastros.where((cadastro) {
        final String orgao = cadastro['para'] != null ? cadastro['para'].toString().toLowerCase() : '';
        final String matricula =
        cadastro['matricula'] != null ? cadastro['matricula'].toString().toLowerCase() : '';
        final String placa = _getPlacasFromVeiculos(cadastro['veiculos']).toLowerCase();

        // Verifica se algum dos campos contém o texto de filtro
        return orgao.contains(filtro) || matricula.contains(filtro) || placa.contains(filtro);
      }).toList();

      setState(() {
        filteredReports = filteredCadastros;
        isLoading = false;
      });
    }).catchError((error) {
      print('Erro ao buscar relatórios: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  String _getPlacasFromVeiculos(List<dynamic>? veiculos) {
    if (veiculos == null || veiculos.isEmpty) {
      return '';
    }

    return veiculos.map((veiculo) => veiculo['placa'] ?? '').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrar Relatórios'),
        backgroundColor: Color(0xFF202F58), // Cor do AppBar
        elevation: 0, // Removendo a sombra da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: filtroController,
              decoration: InputDecoration(
                labelText: 'Filtrar por Orgão, Matrícula ou Placa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showFilteredReports(context);
              },
              child: Text('Filtrar Relatórios'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF43AD59), // Cor de fundo do botão
                onPrimary: Colors.white, // Cor do texto do botão
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
            SizedBox(height: 16),
            // Adiciona uma animação de carregamento enquanto os dados estão sendo filtrados
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF43AD59)), // Cor da animação de carregamento
                ),
              ),
            // Lista de relatórios filtrados
            if (!isLoading && filteredReports.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    return _buildReportEntry(context, filteredReports[index]);
                  },
                ),
              ),
            // Mensagem se nenhum resultado for encontrado
            if (!isLoading && filteredReports.isEmpty)
              Center(
                child: Text(
                  'Nenhum resultado encontrado',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportEntry(BuildContext context, Map<String, dynamic> cadastro) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Nome: ${cadastro['nomeResponsavel'] ?? 'N/A'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orgão: ${cadastro['para'] ?? 'N/A'}'),
            Text('Matrícula: ${cadastro['matricula'] ?? 'N/A'}'),
          ],
        ),
        onTap: () {
          // Implemente o que acontece quando um relatório é pressionado, se necessário
        },
      ),
    );
  }

  @override
  void dispose() {
    filtroController.dispose();
    super.dispose();
  }
}
