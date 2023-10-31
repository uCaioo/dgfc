import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adm.dart';
import 'cadastro.dart'; // Importe o arquivo cadastro.dart
import 'esqueceu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _showPassword = false;

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdmScreen(adminName: "Seja bem-vindo")),
      );
    } catch (e) {
      print("Erro de autenticação: $e");

      // Mostrar mensagem de erro na parte superior da tela
      showErrorSnackbar(context, "Usuário ou senha incorretos");
    }
  }

  // Método para mostrar a mensagem de erro na parte superior da tela
  void showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating, // Permite que o SnackBar flutue sobre outros widgets
        margin: EdgeInsets.all(16.0), // Ajuste as margens conforme necessário
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF202F58),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
      ),

      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF202F58), Color(0xFF0E1A38)],
              ),
            ),

            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo_Governo.png',
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.2,
                    ),

                    SizedBox(height: screenHeight * 0.06),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_showPassword,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF43AD59)),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xFF43AD59),
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => EsqueceuSenhaScreen()), // Navega para a tela de cadastro
                            );
                          },
                          child: Text(
                            'Esqueceu a Senha?',
                            style: TextStyle(color: Color(0xFF43AD59)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    ElevatedButton(
                      onPressed: () {
                        signInWithEmailAndPassword(scaffoldContext);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF43AD59),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.1),
                      ),
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CadastroScreen()), // Navega para a tela de cadastro
                            );
                          },
                          child: Text(
                            'Registre-se',
                            style: TextStyle(color: Color(0xFF43AD59)),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.08),
                    Text(
                      'Departamento de Gestão de Frotas e Combustível DGFC/SEAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.012,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
