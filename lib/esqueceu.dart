import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueceuSenhaScreen extends StatefulWidget {
  @override
  _EsqueceuSenhaScreenState createState() => _EsqueceuSenhaScreenState();
}

class _EsqueceuSenhaScreenState extends State<EsqueceuSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202F58),
      appBar: AppBar(
        title: Text(
          'Esqueceu a Senha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF43AD59),
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Logo_Governo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Digite seu Email',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),


                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF43AD59), width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.8), width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0), // Adicionado espaço vertical
                ],
              ),
            ),


            ElevatedButton(
              onPressed: () {
                _enviarEmailRedefinicaoSenha(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF43AD59),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              child: Text(
                'Enviar Email de Redefinição',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enviarEmailRedefinicaoSenha(BuildContext context) async {
    final String email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Email Enviado com Sucesso!',
              style: TextStyle(color: Color(0xFF202F58)),
            ),
            content: Text(
              'Um email de redefinição de senha foi enviado para $email. '
                  'Por favor, verifique sua caixa de entrada e siga as instruções para redefinir sua senha.',
              style: TextStyle(color: Color(0xFF43AD59)),
              textAlign: TextAlign.center,
            ),


            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Color(0xFF43AD59))),
              ),
            ],
          );
        },
      );


    } catch (e) {
      print('Erro ao enviar e-mail de redefinição de senha: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erro ao Enviar Email',
              style: TextStyle(color: Color(0xFF43AD59)),
            ),
            content: Text(
              'Ocorreu um erro ao enviar o email de redefinição de senha. '
                  'Por favor, verifique se o email inserido está correto e tente novamente.',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Color(0xFF43AD59))),
              ),
            ],
          );
        },
      );
    }
  }

}