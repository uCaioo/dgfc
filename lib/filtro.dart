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

        final String orgao =
        cadastro['para'] != null ? cadastro['para'].toString().toLowerCase() : '';

        final String matricula =
        cadastro['matricula'] != null ? cadastro['matricula'].toString().toLowerCase() : '';

        final String placa = _getPlacasFromVeiculos(cadastro['veiculos']).toLowerCase();

        final String nomeResponsavel =
        cadastro['nomeResponsavel'] != null ? cadastro['nomeResponsavel'].toString().toLowerCase() : '';
         
        final String unidadeRecebedora =
        cadastro['unidadeRecebedora'] != null ? cadastro['unidadeRecebedora'].toString().toLowerCase() : '';

        final String cidade =
        cadastro['cidade'] != null ? cadastro['cidade'].toString().toLowerCase() : '';

        return orgao.contains(filtro) ||
            matricula.contains(filtro) ||
            placa.contains(filtro) ||
            nomeResponsavel.contains(filtro) ||
            unidadeRecebedora.contains(filtro) ||
            cidade.contains(filtro);
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
        title: Text('Pesquisar cadastros'),
        centerTitle: true,
        backgroundColor: Color(0xFF202F58),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF202F58),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),

            TextField(
              controller: filtroController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFF43AD59)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFF43AD59)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                _showFilteredReports(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Buscar',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF43AD59),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),

            SizedBox(height: 16),

            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF43AD59)),
                ),
              ),

            if (!isLoading && filteredReports.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    return _buildReportEntry(context, filteredReports[index]);
                  },
                ),
              ),

            if (!isLoading && filteredReports.isEmpty)
              Center(
                child: Text(
                  'Nenhum resultado encontrado',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportEntry(BuildContext context, Map<String, dynamic> cadastro) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          'Nome: ${cadastro['nomeResponsavel'] ?? 'N/A'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orgão: ${cadastro['para'] ?? 'N/A'}'),
            Text('Matrícula: ${cadastro['matricula'] ?? 'N/A'}'),
            Text('Unidade Recebedora: ${cadastro['unidadeRecebedora'] ?? 'N/A'}'),
            Text('Cidade: ${cadastro['cidade'] ?? 'N/A'}'),
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
