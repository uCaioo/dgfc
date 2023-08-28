import 'package:flutter/material.dart';
import 'dart:async';
import 'cadastro_screen.dart';
import 'select.dart'; // Importe aqui a tela SelectScreen

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _carAnimationController;
  late Animation<Offset> _carAnimation;

  late AnimationController _fuelAnimationController;

  late AnimationController _cardsAnimationController;

  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();

    _carAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fuelAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _cardsAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _startAnimations();
    _startCarAnimationTimer();
  }

  @override
  void dispose() {
    _carAnimationController.dispose();
    _fuelAnimationController.dispose();
    _cardsAnimationController.dispose();
    super.dispose();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));

    _carAnimationController.repeat(reverse: true);
    _fuelAnimationController.forward();
    _cardsAnimationController.forward();
  }

  void _startCarAnimationTimer() {
    Timer.periodic(Duration(seconds: 10), (_) {
      _carAnimationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    _carAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _carAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFF202F58),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: Text('Bem-vindo'),
              backgroundColor: Color(0xFF202F58),
              automaticallyImplyLeading: false, // Impede que o botão de voltar padrão seja exibido
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior (SelectScreen)
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo_Governo.png',
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    SlideTransition(
                      position: _carAnimation,
                      child: Image.asset(
                        'assets/images/car.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Departamento de Gestão de Frotas e Combustível',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'DGFC/SEAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _fuelAnimationController,
                      builder: (context, child) {
                        return Container(
                          width: _fuelAnimationController.value * 100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _cardsAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _cardsAnimationController.value,
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.library_books),
                                  title: Text('Termos e Uso'),
                                  subtitle: Text('Obrigações do Responsável pelos Cartões'),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Termos e Uso',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('TERMO DE ENTREGA DE CARTÃO TITULAR', style: TextStyle(fontWeight: FontWeight.bold)),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Declaro, para fins legais, que recebi o ValeCard de acordo com o quadro acima, contendo informações sobre o respectivo município, a quantidade de cartões e a autorização para o abastecimento por condutores cadastrados. Esses cartões serão utilizados para a liberação de combustível pelo sistema de abastecimento da empresa ValeCard.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Assumo total responsabilidade civil e criminal pela utilização do mencionado CARTÃO, e concordo expressamente com todas as obrigações e condições especificadas abaixo.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'OBRIGAÇÕES DE UTILIZAÇÃO DO CARTÃO VALE-CARD',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  '(A) O cartão ValeCard será emitido para cada veículo individualmente, contendo os dados específicos do respectivo veículo. Esse cartão não poderá ser utilizado em outro veículo ou para qualquer outro tipo de abastecimento que não esteja relacionado ao veículo designado.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  '(B) Fica expressamente proibida ao usuário a comercialização do combustível creditado nos cartões, bem como a transferência do cartão para outro veículo. Quaisquer ocorrências nesse sentido resultarão na apreensão do cartão e na instauração de processos administrativos para investigação de quaisquer irregularidades.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  '(C) Deve-se conservar o cartão cedido para uso no município em que foi entregue, evitando extravios e seu mau uso. Caso ocorra algum extravio, é necessário informar dentro do prazo estabelecido.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Declaro estar ciente dos meus direitos, obrigações e responsabilidades relacionados ao correto uso do Cartão ValeCard que recebi. Assim, assino este termo em duas vias de igual teor e forma, ficando com uma delas em minha posse.',
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Tarcio C. Amorim\nChefe de Departamento de Gestão de Frotas e Combustíveis - DGFC/SEAD',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                onPrimary: Colors.white,
                                              ),
                                              child: Text('Fechar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.account_circle),
                                  title: Text('Termos da LGPD'),
                                  subtitle: Text('Detalhes dos termos'),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Termos da LGPD',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'POLÍTICA DE PRIVACIDADE',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'A sua privacidade é importante para nós. Leia atentamente a nossa Política de Privacidade para entender como coletamos, utilizamos, protegemos e armazenamos suas informações pessoais.',
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'ACEITAÇÃO DOS TERMOS',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Ao utilizar nosso aplicativo, você concorda com os termos da nossa Política de Privacidade e com o tratamento dos seus dados pessoais conforme descrito na mesma.',
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'COLETA DE INFORMAÇÕES',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Explicação sobre a coleta de informações e como elas são utilizadas.',
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Fechar',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    CheckboxListTile(
                      title: Text(
                        'Concordo com os termos',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value!;
                        });
                      },
                      activeColor: Colors.white,
                      checkColor: MaterialStateColor.resolveWith((states) => Colors.black),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: _termsAccepted
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CadastroScreen()),
                        );
                      }
                          : null,
                      icon: Icon(Icons.arrow_forward),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16), // Apenas ajustando o espaçamento vertical
                        child: Text(
                          'Começar cadastro',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: _termsAccepted ? Color(0xFF43AD59) : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
