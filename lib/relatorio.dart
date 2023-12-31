import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';



class RelatorioScreen extends StatefulWidget {
  final List<Map<String, dynamic>> relatorios;
  final Map<String, dynamic>? relatorioEspecifico;

  RelatorioScreen({required this.relatorios, this.relatorioEspecifico});

  @override
  _RelatorioScreenState createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showReports(BuildContext context) {
    FirebaseFirestore.instance.collection('cadastros').get().then((querySnapshot) {
      List<Map<String, dynamic>> cadastros = querySnapshot.docs.map((documentSnapshot) {
        return {...documentSnapshot.data(), 'documentId': documentSnapshot.id};
      }).toList();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Relatórios',
                textAlign: TextAlign.center,
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: cadastros.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildReportEntry(context, cadastros[index]),
                      if (index < cadastros.length - 1) Divider(),
                    ],
                  );
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
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmação'),
                          content: Text('Deseja realmente excluir este relatório?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text('Sim'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      _deleteReport(data['documentId']);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
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
                _generateAndOpenPDF(data);
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


  // Função para gerar e abrir o PDF
  Future<void> _generateAndOpenPDF(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Get the current date and time
    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.day} de ${_getMonthName(currentDate.month)} de ${currentDate.year} ${currentDate.hour}:${currentDate.minute}";

    // Load signature images from Firebase Storage
    final signatureResponsavel = await _loadImageFromFirebaseStorage(data['assinaturaResponsavel']);
    final signatureFiscal = await _loadImageFromFirebaseStorage(data['assinaturaFiscal']);

    // Load images from the assets/images directory
    final headerImage =
    pw.MemoryImage((await rootBundle.load('assets/images/Sead_Sup.png')).buffer.asUint8List());
    final footerImage =
    pw.MemoryImage((await rootBundle.load('assets/images/Sead_inf.png')).buffer.asUint8List());

    // Ajuste a escala das imagens para torná-las maiores
    final double imageScale = 2.0; // Ajuste esse valor conforme necessário

    // Tamanho da fonte para todos os campos
    final double fieldFontSize = 10.0; // Ajuste esse valor conforme necessário

    // Adicione o cabeçalho à página
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          // Adicione o cabeçalho aqui com a escala ajustada
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Image(headerImage, width: 300 * imageScale, height: 100 * imageScale),
          ),

          // Resto do conteúdo do PDF
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Comprovante de Cadastro', style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16.0),
              _buildField('Emissor: ', data['emissor'], fontSize: fieldFontSize),
              _buildField('Para: ', data['para'], fontSize: fieldFontSize),
              _buildField('Unidade Recebedora: ', data['unidadeRecebedora'], fontSize: fieldFontSize),
              _buildField('Cidade:', data['cidade '], fontSize: fieldFontSize),
              _buildField('Nome do Responsável: ', data['nomeResponsavel'], fontSize: fieldFontSize),
              _buildField('Matrícula: ', data['matricula'], fontSize: fieldFontSize),
              pw.SizedBox(height: 16.0),
              _buildField('Data e Hora:', formattedDate, fontSize: fieldFontSize),
              pw.SizedBox(height: 16.0),
              // Adicione as assinaturas aqui
              _buildSignature('Assinatura Responsável:', signatureResponsavel),
              _buildSignature('Assinatura Fiscal:', signatureFiscal),
              pw.SizedBox(height: 16.0),
              _buildVeiculosPDF(data['veiculos'], fontSize: fieldFontSize),
              pw.SizedBox(height: 16.0),
              // Adicione o rodapé aqui com a escala ajustada
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Image(footerImage, width: 300 * imageScale, height: 100 * imageScale),
              ),
            ],
          )

        ],
      ),
    );

    // Salve o PDF em um arquivo temporário
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/comprovante_DGFC_SEAD.pdf");
    await file.writeAsBytes(await pdf.save());

    // Abra o PDF no dispositivo
    await OpenFile.open(file.path);
  }

  Future<pw.MemoryImage> _loadImageFromFirebaseStorage(String imageUrl) async {
    try {
      final Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);
      final imgData = await reference.getData();
      if (imgData != null) {
        return pw.MemoryImage(Uint8List.fromList(imgData));
      } else {
        print('Erro ao carregar imagem do Firebase Storage: Imagem nula');
        return pw.MemoryImage(Uint8List(0)); // Retorna uma imagem vazia em caso de erro
      }
    } catch (e) {
      print('Erro ao carregar imagem do Firebase Storage: $e');
      return pw.MemoryImage(Uint8List(0)); // Retorna uma imagem vazia em caso de erro
    }
  }


  pw.Widget _buildField(String label, String? value, {double fontSize = 10.0}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
        ),
        pw.Expanded(
          child: pw.Text(
            value ?? '-',
            style: pw.TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    final monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return monthNames[month - 1];
  }

  pw.Widget _buildVeiculosPDF(List<dynamic>? veiculos, {double fontSize = 10.0}) {
    if (veiculos == null || veiculos.isEmpty) {
      return pw.SizedBox();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Veículos:',
          style: pw.TextStyle(fontSize: 14.0, fontWeight: pw.FontWeight.bold),
        ),
        for (final veiculo in veiculos)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildField('Placa: ', veiculo['placa'] ?? 'N/A', fontSize: fontSize),
              _buildField('Modelo: ', veiculo['modelo'] ?? 'N/A', fontSize: fontSize),
              _buildField('Cota: ', veiculo['cota'] ?? 'N/A', fontSize: fontSize),
              _buildField('Combustível: ', veiculo['combustivel'] ?? 'N/A', fontSize: fontSize),
              _buildField('Documento: ', veiculo['documento'] ?? 'N/A', fontSize: fontSize),
              pw.SizedBox(height: 10.0),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildSignature(String title, pw.MemoryImage image) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 12.0, fontWeight: pw.FontWeight.bold),
        ),
        pw.Image(image, width: 150, height: 50),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        centerTitle: true, // Isso centraliza o título na AppBar
        backgroundColor: Color(0xFF202F58),
      ),
      backgroundColor: Color(0xFF202F58), // Cor de fundo para toda a tela
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color(0xFF43AD59), // Cor do Card
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
                        Icons.description,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 8),
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

} //final