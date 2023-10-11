import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueceuSenhaScreen extends StatefulWidget {
  @override
  _EsqueceuSenhaScreenState createState() => _EsqueceuSenhaScreenState();
}

class _EsqueceuSenhaScreenState extends State<EsqueceuSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF202F58),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF202F58), Color(0xFF0E1A38)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.06),
                  Image.asset(
                    'assets/images/Logo_Governo.png',
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF43AD59)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _enviarEmailRedefinicaoSenha(context),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF43AD59),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.1),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                      : Text(
                    'Enviar Email de Redefinição',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _enviarEmailRedefinicaoSenha(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
