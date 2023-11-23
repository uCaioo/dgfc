import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'select.dart'; // Importe a tela SelectScreen
import 'agradecimento.dart'; // Importe a tela AgradecimentoScreen
import 'package:firebase_core/firebase_core.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define o estilo da barra de status do aplicativo
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/', // Defina a rota inicial
      routes: {
        '/': (context) => LoadingScreen(), // Rota para a tela de carregamento
        '/select': (context) => SelectScreen(), // Rota para a tela de seleção
        '/agradecimento': (context) => AgradecimentoScreen(
          emissor: 'Emissor',
          para: 'Para',
          unidadeRecebedora: 'Unidade Recebedora',
          cidade: 'Cidade',
          nomeResponsavel: 'Nome do Responsável',
          matricula: 'Matrícula',
          assinatura: Uint8List.fromList([]), // Substitua pelo valor real da assinatura
          assinatura2: Uint8List.fromList([]), // Substitua pelo valor real da segunda assinatura
          veiculos: [
            {
              'placa': 'Placa 1',
              'modelo': 'Modelo 1',
              'cota': 'Cota 1',
              'combustivel': 'Combustível 1',
              'documento': 'Documento 1',
            },

            {
              'placa': 'Placa 2',
              'modelo': 'Modelo 2',
              'cota': 'Cota 2',
              'combustivel': 'Combustível 2',
              'documento': 'Documento 2',
            },
            // Adicione mais veículos conforme necessário
          ],
        ),

      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Adiciona um atraso de 3 segundos antes de navegar para a tela de seleção
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/select'); // Navega para a tela de seleção
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }

} //final
