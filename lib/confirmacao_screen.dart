import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'agradecimento.dart'; // Certifique-se de importar a classe AgradecimentoScreen
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe a biblioteca do Cloud Firestore
import 'package:firebase_storage/firebase_storage.dart';



class ConfirmacaoScreen extends StatelessWidget {
  final String emissor;
  final String para;
  final String unidadeRecebedora;
  final String cidade;
  final String nomeResponsavel;
  final String matricula;
  final Uint8List assinatura;
  final Uint8List assinatura2; // Adicione a segunda assinatura aqui
  final List<Map<String, String>> veiculos;


  ConfirmacaoScreen({
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
        title: Text('Confirmação de Cadastro'),
        backgroundColor: Color(0xFF43AD59),
      ),
      body: Container(
        color: Color(0xFF202F58), // Cor de fundo para cobrir o espaço em branco
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho com imagem dentro do container
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset(
                      'assets/images/Sead_Sup.png', fit: BoxFit.contain),
                ),
              ),
              // Corpo do formulário centralizado
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responsabilidade dos Cartões',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Emissor: $emissor',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      Text(
                        'Para: $para',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      Text(
                        'Unidade Recebedora: $unidadeRecebedora',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      Text(
                        'Cidade: $cidade',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      Text(
                        'Nome do Responsável: $nomeResponsavel',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      Text(
                        'Matrícula: $matricula',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Assinatura do responsável pelos cartões:',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: 200,
                        height: 100,
                        child: Image.memory(assinatura, fit: BoxFit.contain),
                      ),

                      SizedBox(height: 16.0),
                      Text(
                        'Assinatura do fiscal:',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: 200,
                        height: 100,
                        child: Image.memory(assinatura2, fit: BoxFit.contain),
                      ),

                      SizedBox(height: 16.0),
                      Text(
                        'Dados do Veículo:',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left, // Alinha o texto à esquerda
                      ),
                      SizedBox(height: 10.0),
                      for (var i = 0; i < veiculos.length; i++)
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Veículo ${i + 1}:',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF43AD59),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Placa: ${veiculos[i]['placa']}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Modelo: ${veiculos[i]['modelo']}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Cota: ${veiculos[i]['cota']}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Combustível: ${veiculos[i]['combustivel']}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Documento: ${veiculos[i]['documento']}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Botão "Gerar comprovante"
                      Center(
                        child: Column(
                          children: [

                            // Botão "Finalizar Cadastro"
                            ElevatedButton(
                              onPressed: () async {
                                // Mostrar um diálogo de confirmação
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Confirmar Cadastro",
                                        style: TextStyle(
                                          color: Color(0xFF202F58), // Cor do título
                                        ),
                                      ),
                                      content: Text(
                                        "Deseja realmente finalizar o cadastro?",
                                        style: TextStyle(
                                          color: Color(0xFF202F58), // Cor do conteúdo
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false); // Não confirmado
                                          },
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                              color: Colors.red, // Cor do texto do botão
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true); // Confirmado
                                          },
                                          child: Text(
                                            "Confirmar",
                                            style: TextStyle(
                                              color: Color(0xFF43AD59), // Cor do texto do botão
                                            ),
                                          ),
                                        ),
                                      ],
                                      backgroundColor: Colors.white, // Cor de fundo da janela
                                    );
                                  },
                                );



                                // Função para fazer upload da imagem para o Firebase Storage
                                Future<String> uploadImageAndGetUrl(Uint8List imageBytes, String imageName, String documentoNome) async {
                                  String imageUrl = '';

                                  try {
                                    Reference storageReference = FirebaseStorage.instance.ref().child('assinaturas').child(documentoNome).child(imageName);
                                    UploadTask uploadTask = storageReference.putData(imageBytes);
                                    await uploadTask.whenComplete(() => null);
                                    imageUrl = await storageReference.getDownloadURL();
                                  } catch (e) {
                                    print('Erro ao fazer upload de imagem: $e');
                                  }

                                  return imageUrl;
                                }

// Verificar se o usuário confirmou
                                if (confirm == true) {
                                  // Mostrar a animação de carregamento
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false, // Impedir o fechamento do diálogo
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF43AD59)), // Cor da animação
                                        ),
                                      );
                                    },
                                  );

                                  try {
                                    // Criar um nome único para o documento (com base no nome do responsável e um timestamp)
                                    String documentoNome = '${nomeResponsavel}_${DateTime.now().millisecondsSinceEpoch}';

                                    // Upload das assinaturas para o Firebase Storage
                                    final responsavelImageUrl = await uploadImageAndGetUrl(assinatura, 'assinatura_responsavel.png', documentoNome);
                                    final fiscalImageUrl = await uploadImageAndGetUrl(assinatura2, 'assinatura_fiscal.png', documentoNome);

                                    // Criar mapa de dados para enviar ao Firestore
                                    Map<String, dynamic> data = {
                                      'emissor': emissor,
                                      'para': para,
                                      'unidadeRecebedora': unidadeRecebedora,
                                      'cidade': cidade,
                                      'nomeResponsavel': nomeResponsavel,
                                      'matricula': matricula,
                                      'assinaturaResponsavel': responsavelImageUrl,
                                      'assinaturaFiscal': fiscalImageUrl,
                                      'veiculos': veiculos,
                                    };

                                    // Referência à coleção "cadastros"
                                    CollectionReference cadastros = FirebaseFirestore.instance.collection('cadastros');

                                    // Criar o documento com o nome único
                                    DocumentReference cadastroRef = cadastros.doc(documentoNome);

                                    // Enviar dados para o Firestore
                                    await cadastroRef.set(data);

                                    // Fechar o diálogo de carregamento
                                    Navigator.of(context).pop();

                                    // Navegar para a tela de agradecimento
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AgradecimentoScreen(
                                          emissor: emissor,
                                          para: para,
                                          unidadeRecebedora: unidadeRecebedora,
                                          cidade: cidade,
                                          nomeResponsavel: nomeResponsavel,
                                          matricula: matricula,
                                          assinatura: assinatura,
                                          assinatura2: assinatura2,
                                          veiculos: veiculos,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Erro ao finalizar cadastro: $e');
                                    // Tratar o erro, se necessário
                                    Navigator.of(context).pop(); // Fechar o diálogo de carregamento
                                  }
                                }
                              },
                              child: Text(
                                'Finalizar Cadastro',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 18.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF43AD59), // Cor de fundo do botão
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),


                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              // Rodapé com imagem dentro do container
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset(
                      'assets/images/Sead_inf.png', fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

} //final