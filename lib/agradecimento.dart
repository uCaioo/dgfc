import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AgradecimentoScreen extends StatelessWidget {
  final String emissor;
  final String para;
  final String unidadeRecebedora;
  final String cidade;
  final String nomeResponsavel;
  final String matricula;
  final Uint8List assinatura;
  final Uint8List assinatura2; // Adicione a segunda assinatura aqui
  final List<Map<String, String>> veiculos;

  AgradecimentoScreen({
    required this.emissor,
    required this.para,
    required this.unidadeRecebedora,
    required this.cidade,
    required this.nomeResponsavel,
    required this.matricula,
    required this.assinatura,
    required this.assinatura2, // Adicione a segunda assinatura aqui
    required this.veiculos,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove a seta de volta
        title: SizedBox.shrink(), // Remove o título da AppBar
        backgroundColor: Color(0xFF202F58),
      ),
      body: Container(
        color: Color(0xFF202F58),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thumb_up,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Obrigado pelo cadastro!',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Seu cadastro foi concluído com sucesso.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  _gerarPDF();
                },
                icon: Icon(Icons.file_download),
                label: Text(
                  'Gerar Comprovante',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF43AD59),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  minimumSize: Size(200, 0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  exit(0); // Fecha o aplicativo
                },
                child: Text(
                  'Sair',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  minimumSize: Size(200, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para gerar e abrir o PDF
  Future<void> _gerarPDF() async {
    final pdf = pw.Document();

    // Load images from the assets/images directory
    final headerImage = (await rootBundle.load('assets/images/Sead_Sup.png'))
        .buffer.asUint8List();
    final footerImage = (await rootBundle.load('assets/images/Sead_inf.png'))
        .buffer.asUint8List();

    // Get the current date and time
    final currentDate = DateTime.now();
    final formattedDate = "${currentDate.day} de ${_getMonthName(
        currentDate.month)} de ${currentDate.year} ${currentDate
        .hour}:${currentDate.minute}";

    // Create the PDF content
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Comprovante de Cadastro',
                  style: pw.TextStyle(
                      fontSize: 20.0, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10.0),
              pw.Text('Emissor: $emissor'),
              pw.Text('Para: $para'),
              pw.Text('Unidade Recebedora: $unidadeRecebedora'),
              pw.Text('Cidade: $cidade'),
              pw.Text('Nome do Responsável: $nomeResponsavel'),
              pw.Text('Matrícula: $matricula'),
              pw.SizedBox(height: 16.0),
              pw.Text(
                'Assinatura do responsável pelos cartões:',
                style: pw.TextStyle(fontSize: 14.0),
              ),
              pw.SizedBox(height: 5.0),
              pw.Container(
                width: 100,
                height: 80,
                child: pw.Image(pw.MemoryImage(assinatura)),
              ),
              pw.SizedBox(height: 16.0),
              pw.Text(
                'Assinatura do fiscal:',
                style: pw.TextStyle(
                  fontSize: 16.0,
                ),
              ),
              pw.SizedBox(height: 5.0),
              pw.Container(
                width: 100,
                height: 80,
                child: pw.Image(pw.MemoryImage(assinatura2)),
              ),
              pw.SizedBox(height: 16.0),
              pw.Text(
                'Dados do Veículo:',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10.0),
              for (var i = 0; i < veiculos.length; i++)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Veículo ${i + 1}:',
                      style: pw.TextStyle(
                        fontSize: 18.0,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.SizedBox(height: 8.0),
                    pw.Text('Placa: ${veiculos[i]['placa']}'),
                    pw.Text('Modelo: ${veiculos[i]['modelo']}'),
                    pw.Text('Cota: ${veiculos[i]['cota']}'),
                    pw.Text('Combustível: ${veiculos[i]['combustivel']}'),
                    pw.Text('Documento: ${veiculos[i]['documento']}'),
                    pw.SizedBox(height: 16.0),
                  ],
                ),
            ],
          ),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              "Manaus - $formattedDate",
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Image(pw.MemoryImage(headerImage)),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Image(pw.MemoryImage(footerImage)),
          );
        },
      ),
    );

    // Save the PDF to a temporary file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/comprovante_DGFC_SEAD.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF on the device
    await OpenFile.open(file.path);
  }

  String _getMonthName(int month) {
    const monthNames = {
      1: 'Janeiro', 2: 'Fevereiro', 3: 'Março', 4: 'Abril',
      5: 'Maio', 6: 'Junho', 7: 'Julho', 8: 'Agosto',
      9: 'Setembro', 10: 'Outubro', 11: 'Novembro', 12: 'Dezembro',
    };
    return monthNames[month] ?? '';
  }

}