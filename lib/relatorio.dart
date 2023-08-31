import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'dart:io';

class RelatorioScreen extends StatelessWidget {
  void _showReports(BuildContext context) {
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
                  return _buildReportEntry(context, cadastros[index]);
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

  Widget _buildReportEntry(BuildContext context, Map<String, dynamic> cadastro) {
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
        _showDetailsFromReport(context, cadastro);
      },
    );
  }

  void _showDetailsFromReport(BuildContext context, Map<String, dynamic> data) {
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
                  onPressed: () async {
                    // Mostrar diálogo de confirmação
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmação'),
                          content: Text('Deseja realmente excluir este relatório?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false); // Não confirmar
                              },
                              child: Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true); // Confirmar
                              },
                              child: Text('Sim'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      _deleteReport(data['documentId']);
                      Navigator.pop(context); // Feche o diálogo de detalhes
                    }
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
              onPressed: () async {
                // Gerar PDF e salvar em um arquivo
                final pdf = await generatePdf(data);
                final pdfFile = await savePdf(pdf);

                // Abrir o PDF
                await openPdf(pdfFile.path);
              },
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

  Future<pw.Document> generatePdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    final headerImagePath = 'assets/images/Sead_Sup.png';
    final footerImagePath = 'assets/images/Sead_inf.png';

    final headerImage = pw.MemoryImage(File(headerImagePath).readAsBytesSync());
    final footerImage = pw.MemoryImage(File(footerImagePath).readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho personalizado com imagem
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Image(headerImage),
              ),
              pw.SizedBox(height: 20), // Espaçamento entre cabeçalho e conteúdo

              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Cabeçalho do Relatório'),
                    pw.Text('Data: ${DateTime.now().toString()}'),
                  ],
                ),
              ),
              _buildDetailText('Detalhes do Cadastro', ''),
              _buildDetailText('Nome do Responsável', data['nomeResponsavel'] ?? 'N/A'),
              _buildDetailText('Emissor', data['emissor']),
              _buildDetailText('Para', data['para']),
              _buildDetailText('Unidade Recebedora', data['unidadeRecebedora']),
              _buildDetailText('Cidade', data['cidade']),
              // Adicione mais detalhes conforme necessário

              pw.SizedBox(height: 20), // Espaçamento entre conteúdo e rodapé
              // Rodapé personalizado com imagem
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Image(footerImage),
              ),
            ],
          );
        },
      ),
    );

    // ... Continue adicionando mais páginas e conteúdo conforme necessário ...

    return pdf;
  }

  pw.Widget _buildDetailText(String label, String? value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.RichText(
        text: pw.TextSpan(
          style: pw.TextStyle(fontSize: 14.0),
          children: [
            pw.TextSpan(text: '$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TextSpan(text: value ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Future<File> savePdf(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final pdfBytes = await pdf.save();
    final pdfFile = File('${output.path}/relatorio.pdf');
    await pdfFile.writeAsBytes(pdfBytes);
    return pdfFile;
  }

  Future<void> openPdf(String path) async {
    final file = File(path);
    final openResult = await OpenFile.open(file.path);
    if (openResult.type == ResultType.error) {
      print('Erro ao abrir o arquivo PDF.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        backgroundColor: Color(0xFF202F58),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color(0xFF43AD59), // Cor #43AD59
              elevation: 4, // Elevação do card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Borda arredondada
              ),
              child: InkWell(
                onTap: () {
                  _showReports(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description, // Ícone de relatório
                        color: Colors.white,
                        size: 32, // Tamanho do ícone
                      ),
                      SizedBox(height: 8), // Espaçamento entre o ícone e o texto
                      Text(
                        'Mostrar Relatórios',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}