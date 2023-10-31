import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'confirmacao_screen.dart';

class CadastroVeiculoScreen extends StatefulWidget {
  final String emissor;
  final String para;
  final String unidadeRecebedora;
  final String nomeResponsavel;
  final String matricula;
  final String cidade;
  final Uint8List assinatura;
  final Uint8List assinatura2; // Adicione esta linha para a segunda assinatura

  CadastroVeiculoScreen({
    required this.emissor,
    required this.para,
    required this.unidadeRecebedora,
    required this.nomeResponsavel,
    required this.matricula,
    required this.cidade,
    required this.assinatura,
    required this.assinatura2, // Adicione esta linha para a segunda assinatura
  });

  @override
  _CadastroVeiculoScreenState createState() => _CadastroVeiculoScreenState();
}

class _CadastroVeiculoScreenState extends State<CadastroVeiculoScreen> {
  List<Map<String, dynamic>> _veiculos = [];
  List<Map<String, String>> _veiculosConfirmados = [];

  bool _canContinue() {
    for (var veiculo in _veiculos) {
      if (veiculo.containsValue('')) {
        return false;
      }
    }
    return true;
  }

  void _confirmarVeiculos() {
    _veiculosConfirmados.clear();
    for (var veiculo in _veiculos) {
      if (!veiculo.containsValue('')) {
        _veiculosConfirmados.add({
          'placa': veiculo['placa'],
          'modelo': veiculo['modelo'],
          'cota': veiculo['cota'],
          'combustivel': veiculo['combustivel'],
          'documento': veiculo['documento'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo'),
        backgroundColor: Color(0xFF202F58),
      ),
      body: Container(
        color: Color(0xFF202F58),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _veiculos.add({
                                'placa': '',
                                'modelo': '',
                                'cota': '',
                                'combustivel': '',
                                'documento': '',
                                'confirmed': false,
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF43AD59),
                            onPrimary: Colors.white,
                          ),
                          child: Text('Adicionar Veículo'),
                        ),
                        SizedBox(height: 16.0),
                        for (int i = 0; i < _veiculos.length; i++)
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Veículo ${i + 1}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF43AD59)),
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomFormField(
                                    title: 'Placa',
                                    icon: Icons.directions_car,
                                    hintText: 'Digite a placa do veículo',
                                    initialValue: _veiculos[i]['placa'],
                                    onChanged: (value) {
                                      setState(() {
                                        _veiculos[i]['placa'] = value;
                                      });
                                    },
                                    enabled: !_veiculos[i]['confirmed'],
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomFormField(
                                    title: 'Modelo',
                                    icon: Icons.car_rental,
                                    hintText: 'Digite o modelo do veículo',
                                    initialValue: _veiculos[i]['modelo'],
                                    onChanged: (value) {
                                      setState(() {
                                        _veiculos[i]['modelo'] = value;
                                      });
                                    },
                                    enabled: !_veiculos[i]['confirmed'],
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomFormField(
                                    title: 'Cota',
                                    icon: Icons.grid_view,
                                    hintText: 'Digite a cota de combustível do veículo',
                                    initialValue: _veiculos[i]['cota'],
                                    onChanged: (value) {
                                      setState(() {
                                        _veiculos[i]['cota'] = value;
                                      });
                                    },
                                    enabled: !_veiculos[i]['confirmed'],
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomFormField(
                                    title: 'Combustível',
                                    icon: Icons.local_gas_station,
                                    hintText: 'Digite o tipo de combustível',
                                    initialValue: _veiculos[i]['combustivel'],
                                    onChanged: (value) {
                                      setState(() {
                                        _veiculos[i]['combustivel'] = value;
                                      });
                                    },
                                    enabled: !_veiculos[i]['confirmed'],
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomFormField(
                                    title: 'Documento',
                                    icon: Icons.description,
                                    hintText: 'Digite o documento do veículo',
                                    initialValue: _veiculos[i]['documento'],
                                    onChanged: (value) {
                                      setState(() {
                                        _veiculos[i]['documento'] = value;
                                      });
                                    },
                                    enabled: !_veiculos[i]['confirmed'],
                                  ),
                                  SizedBox(height: 8.0),
                                  if (!_veiculos[i]['confirmed'])
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _veiculos.removeAt(i);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 18.0),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Color(0xFF202F58),
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _canContinue()
                      ? () {
                    _confirmarVeiculos();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmacaoScreen(
                          nomeResponsavel: widget.nomeResponsavel,
                          unidadeRecebedora: widget.unidadeRecebedora,
                          cidade: widget.cidade,
                          matricula: widget.matricula,
                          assinatura: widget.assinatura,
                          veiculos: _veiculosConfirmados,
                          emissor: widget.emissor,
                          para: widget.para,
                          assinatura2: widget.assinatura2,
                        ),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF43AD59),
                    onPrimary: Colors.white,
                  ),
                  child: Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String title;
  final IconData icon;
  final String hintText;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  CustomFormField({
    required this.title,
    required this.icon,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF43AD59)),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Icon(icon, color: Color(0xFF43AD59)),
            SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF43AD59), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                initialValue: initialValue,
                enabled: enabled,
              ),
            ),
          ],
        ),
      ],
    );
  }

} //final

