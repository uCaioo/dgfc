import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'cadastro_veiculo_screen.dart';
import 'dart:typed_data';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  final SignatureController _signatureController2 = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  String _emissor = 'Departamento de Gestão de Frotas e Combustível - DGFC/SEAD';
  String _para = '';
  String _unidadeRecebedora = '';
  String _nomeResponsavel = '';
  String _matricula = '';
  String _cidade = 'Manaus-AM';
  bool _isFieldsFilled = false;

  void _limparAssinaturaResponsavel() {
    _signatureController.clear();
  }

  void _limparAssinaturaFiscal() {
    _signatureController2.clear();
  }


  void _navegarParaCadastroVeiculo() async {
    Uint8List? signatureBytes = await _signatureController.toPngBytes();
    Uint8List? signatureBytes2 = await _signatureController2.toPngBytes();
    if (signatureBytes != null && signatureBytes2 != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroVeiculoScreen(
            emissor: _emissor,
            para: _para,
            unidadeRecebedora: _unidadeRecebedora,
            nomeResponsavel: _nomeResponsavel,
            cidade: _cidade,
            matricula: _matricula,
            assinatura: signatureBytes,
            assinatura2: signatureBytes2,
          ),
        ),
      );
    } else {
      // Tratar o cenário onde a assinatura não foi capturada corretamente
      // ou ocorreu algum erro ao converter para bytes.
      // Nesse caso, você pode mostrar um diálogo de erro ou tomar outra ação apropriada.
    }
  }

  void _checkFieldsFilled() {
    setState(() {
      _isFieldsFilled =
          _para.isNotEmpty &&
              _unidadeRecebedora.isNotEmpty &&
              _nomeResponsavel.isNotEmpty &&
              _matricula.isNotEmpty &&
              _cidade.isNotEmpty;
    });
  }

  Widget _buildFormFieldWithIcon(
      String label,
      IconData icon,
      String hintText,
      String value,
      void Function(String) onChanged,
      [List<String>? dropdownOptions]
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF43AD59),
          ),
        ),
        SizedBox(height: 4.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Color(0xFF43AD59), width: 2.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: Color(0xFF43AD59),
                ),
              ),
              Expanded(
                child: dropdownOptions != null
                    ? DropdownButtonFormField<String>(
                  value: value,
                  onChanged: (String? newValue) {
                    onChanged(newValue!);
                    _checkFieldsFilled();
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '',
                      child: Text('Selecione o orgão'),
                    ),
                    ...dropdownOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ],
                  style: TextStyle(color: Color(0xFF202F58)),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF202F58),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 10.0,
                    ),
                  ),
                  isExpanded: true, // Define o botão para expandir horizontalmente
                )
                    : TextFormField(
                  onChanged: onChanged,
                  initialValue: value,
                  style: TextStyle(color: Color(0xFF202F58)),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF202F58),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 10.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0), // Espaço para separar os ícones do campo
            ],
          ),
        ),
      ],
    );
  }






  List<String> secretarias = [
    'AGÊNCIA AMAZONENSE DE DESENVOLVIMENTO CULTURAL – AADC',
    'AGÊNCIA AMAZONENSE DE DESENVOLVIMENTO ECONÔMICO,SOCIAL E AMBIENTAL – AADESAM',
    'AGÊNCIA DE DEFESA AGROPECUÁRIA E FLORESTAL DO ESTADO DO AMAZONAS – ADAF',
    'AGÊNCIA DE DESENVOLVIMENTO E FOMENTO DO ESTADO DO AMAZONAS – AFEAM',
    'AGÊNCIA DE DESENVOLVIMENTO SUSTENTÁVEL DO AMAZONAS – ADS',
    'AGÊNCIA REGULADORA DOS SERVIÇOS PÚBLICOS DELEGADOS E CONTRATADOS DO ESTADO DO AMAZONAS – ARSEPAM',
    'CENTRO DE EDUCAÇÃO TECNOLÓGICA DO AMAZONAS – CETAM',
    'CENTRO DE SERVIÇOS COMPARTILHADOS – CSC',
    'COMPANHIA AMAZONENSE DE DESENVOLVIMENTO E MOBILIZAÇÃO DE ATIVOS – CADA',
    'COMPANHIA DE DESENVOLVIMENTO DO ESTADO DO AMAZONAS – CIAMA',
    'COMPANHIA DE GÁS DO ESTADO DO AMAZONAS – CIGÁS',
    'COMPANHIA DE SANEAMENTO DO AMAZONAS – COSAMA',
    'CONSELHO DE DESENVOLVIMENTO DO ESTADO DO AMAZONAS – CODAM',
    'CONTROLADORIA GERAL DO ESTADO – CGE',
    'CORPO DE BOMBEIROS MILITAR DO ESTADO DO AMAZONAS – CBMAM',
    'DEPARTAMENTO ESTADUAL DE TR NSITO – DETRAN',
    'EMPRESA ESTADUAL DE TURISMO – AMAZONASTUR',
    'ESCRITÓRIO DE REPRESENTAÇÃO DO GOVERNO, EM SÃO PAULO – ERGSP',
    'FUNDAÇÃO CENTRO DE CONTROLE DE ONCOLOGIA DO ESTADO DO AMAZONAS – FCECON',
    'FUNDAÇÃO DE AMPARO À PESQUISA DO ESTADO DO AMAZONAS – FAPEAM',
    'FUNDAÇÃO DE MEDICINA TROPICAL “DOUTOR HEITOR VIEIRA DOURADO – FMT-AM',
    'FUNDAÇÃO DE VIGIL NCIA EM SAÚDE DO ESTADO DO AMAZONAS DRA. ROSEMARY COSTA PINTO- FVS/RCP',
    'FUNDAÇÃO ESTADUAL DO ÍNDIO – FEI',
    'FUNDAÇÃO FUNDO PREVIDENCIÁRIO DO ESTADO DO AMAZONAS – AMAZONPREV',
    'FUNDAÇÃO HOSPITAL DO CORAÇÃO “FRANCISCA MENDES” – FHCFM',
    'FUNDAÇÃO HOSPITAL “ADRIANO JORGE” – FHAJ',
    'FUNDAÇÃO HOSPITALAR DE DERMATOLOGIA TROPICAL E VENEREOLOGIA “ALFREDO DA MATTA” – FUHAM',
    'FUNDAÇÃO HOSPITALAR DE HEMATOLOGIA E HEMOTERAPIA DO AMAZONAS – FHEMOAM',
    'FUNDAÇÃO TELEVISÃO E RÁDIO CULTURA DO AMAZONAS – FUNTEC',
    'FUNDAÇÃO UNIVERSIDADE ABERTA DA TERCEIRA IDADE – FUNATI',
    'IMPRENSA OFICIAL DO ESTADO DO AMAZONAS – IOA',
    'INSTITUTO DE DEFESA DO CONSUMIDOR – PROCON/AM',
    'INSTITUTO DE DESENVOLVIMENTO AGROPECUÁRIO E FLORESTAL SUSTENTÁVEL DO ESTADO DO AMAZONAS – IDAM',
    'INSTITUTO DE PESOS E MEDIDAS – IPEM',
    'INSTITUTO DE PROTEÇÃO AMBIENTAL DO AMAZONAS – IPAAM',
    'JUNTA COMERCIAL DO ESTADO DO AMAZONAS – JUCEA',
    'POLÍCIA CIVIL DO ESTADO – PC',
    'POLÍCIA MILITAR DO AMAZONAS – PMAM',
    'PROCESSAMENTO DE DADOS DO AMAZONAS – PRODAM ',
    'PROCURADORIA GERAL DO ESTADO – PGE',
    'SECRETARIA DE ADMINISTRAÇÃO E GESTÃO – SEAD',
    'SECRETARIA DE ESTADO DA ASSISTÊNCIA SOCIAL – SEAS',
    'SECRETARIA DE ESTADO DA CASA CIVIL',
    'SECRETARIA DE ESTADO DA CASA MILITAR',
    'SECRETARIA DE ESTADO DA FAZENDA – SEFAZ',
    'SECRETARIA DE ESTADO DAS CIDADES E TERRITÓRIOS – SECT',
    'SECRETARIA DE ESTADO DE ADMINISTRAÇÃO PENITENCIÁRIA – SEAP',
    'SECRETARIA DE ESTADO DE COMUNICAÇÃO SOCIAL – SECOM',
    'SECRETARIA DE ESTADO DE CULTURA E ECONOMIA CRIATIVA – SEC',
    'SECRETARIA DE ESTADO DE DESENVOLVIMENTO ECONÔMICO, CIÊNCIA, TECNOLOGIA E INOVAÇÃO – SEDECTI',
    'SECRETARIA DE ESTADO DE DESENVOLVIMENTO URBANO E METROPOLITANO - SEDURB',
    'SECRETARIA DE ESTADO DE EDUCAÇÃO E DESPORTO ESCOLAR – SEDUC',
    'SECRETARIA DE ESTADO DE ENERGIA, MINERAÇÃO E GÁS - SEMEP',
    'SECRETARIA DE ESTADO DE INFRAESTRUTURA – SEINFRA',
    'SECRETARIA DE ESTADO DE JUSTIÇA, DIREITOS HUMANOS E CIDADANIA – SEJUSC',
    'SECRETARIA DE ESTADO DE PRODUÇÃO RURAL – SEPROR',
    'SECRETARIA DE ESTADO DE RELAÇÕES FEDERATIVAS E INTERNACIONAIS – SERFI',
    'SECRETARIA DE ESTADO DE SAÚDE – SES/AM',
    'SECRETARIA DE ESTADO DE SEGURANÇA PÚBLICA – SSP',
    'SECRETARIA DE ESTADO DO DESPORTO E LAZER - SEDEL',
    'SECRETARIA DE ESTADO DO MEIO AMBIENTE – SEMA',
    'SECRETARIA DE GOVERNO – SEGOV',
    'SECRETARIA EXECUTIVA DE DEFESA CIVIL DO ESTADO',
    'SECRETARIA EXECUTIVA DO FUNDO DE PROMOÇÃO SOCIAL E ERRADICAÇÃO DA POBREZA – FPS',
    'SUPERINTENDÊNCIA DE HABITAÇÃO – SUHAB',
    'SUPERINTENDÊNCIA ESTADUAL DE NAVEGAÇÃO, PORTOS E HIDROVIAS – SNPH',
    'UNIDADE DE GERENCIAMENTO DO PROGRAMA DE ACELERAÇÃO DO DESENVOLVIMENTO DA EDUCAÇÃO DO AMAZONAS (UGP-PADEAM)',
    'UNIDADE DE GESTÃO INTEGRADA – UGI',
    'UNIDADE GESTORA DE PROJETOS ESPECIAIS – UGPE',
    'UNIVERSIDADE DO ESTADO DO AMAZONAS – UEA',
    // Adicione mais secretarias conforme necessário
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF43AD59),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF43AD59),
          selectionHandleColor: Color(0xFF43AD59),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Color(0xFF43AD59),
          hoverColor: Color(0xFF43AD59),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
            child: Text(
              'Cadastro do Responsável',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xFF43AD59),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFF202F58),
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFF43AD59),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emissor:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43AD59),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _emissor,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      _buildFormFieldWithIcon(
                        'Para',
                        Icons.home,
                        'Selecione a secretaria',
                        _para,
                            (String value) {
                          setState(() {
                            _para = value;
                            _checkFieldsFilled();
                          });
                        },
                        secretarias, // Usando a lista de secretarias como dropdownOptions
                      ),


                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      _buildFormFieldWithIcon(
                        'Unidade Recebedora',
                        Icons.business,
                        'Digite a unidade recebedora',
                        _unidadeRecebedora,
                            (value) {
                          setState(() {
                            _unidadeRecebedora = value;
                            _checkFieldsFilled();
                          });
                        },
                      ),
                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      _buildFormFieldWithIcon(
                        'Cidade',
                        Icons.location_city,
                        'Digite a cidade',
                        _cidade,
                            (value) {
                          setState(() {
                            _cidade = value;
                            _checkFieldsFilled();
                          });
                        },
                      ),
                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      _buildFormFieldWithIcon(
                        'Nome do Responsável pelos Cartões',
                        Icons.person,
                        'Digite o nome do responsável',
                        _nomeResponsavel,
                            (value) {
                          setState(() {
                            _nomeResponsavel = value;
                            _checkFieldsFilled();
                          });
                        },
                      ),
                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      _buildFormFieldWithIcon(
                        'Matrícula',
                        Icons.badge,
                        'Digite a matrícula do responsável',
                        _matricula,
                            (value) {
                          setState(() {
                            _matricula = value;
                            _checkFieldsFilled();
                          });
                        },
                      ),
                      SizedBox(height: 24.0), // Espaço entre a assinatura e o botão "Enviar"
                      Text(
                        'Assinatura do responsável pelos cartões:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43AD59),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFF43AD59), width: 2.0),
                        ),
                        child: Stack(
                          children: [
                            Signature(
                              controller: _signatureController,
                              height: 110,
                              backgroundColor: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: _limparAssinaturaResponsavel, // Use a função de limpeza do responsável aqui
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 24.0), // Espaço abaixo do campo de assinatura
                      Text(
                        'Assinatura do fiscal:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43AD59),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFF43AD59), width: 2.0),
                        ),
                        child: Stack(
                          children: [
                            Signature(
                              controller: _signatureController2,
                              height: 110,
                              backgroundColor: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: _limparAssinaturaFiscal, // Use a função de limpeza do fiscal aqui
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 24.0), // Espaço abaixo dos campos de assinatura
                      Center(
                        child: ElevatedButton(
                          onPressed: _isFieldsFilled ? _navegarParaCadastroVeiculo : null,
                          child: Text('Enviar'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF43AD59),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            minimumSize: Size(200, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

} //final