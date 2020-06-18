import 'package:flutter/material.dart';
import 'config_blue.dart';

class TelaConfigWiFi extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => TelaConfigWiFiState();
}

class TelaConfigWiFiState extends State<TelaConfigWiFi> {

  bool _alterarRede = false;
  String _textoBotao = 'Alterar Wi-Fi';

  TextEditingController _controleNome = new TextEditingController();
  TextEditingController _controleSenha = new TextEditingController();

  String _nome = "Nome da rede";
  String _senha = "Senha da rede";
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView( 
        child: Column(    
          children: [
            /// Título da Página
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom:20),
              child: Text(
                'Envio das credenciais da rede para a ESP32',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
             
            // Nome Wi-Fi ---------------------------------------
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextField(
                enabled: _alterarRede,
                controller: _controleNome,
                decoration: InputDecoration(
                  hintText: (_controleNome.text.isEmpty) ? _nome : _controleNome.text,
                  icon: Icon(
                    Icons.network_wifi
                  ),
                ),
              ),
            ),
                
            // Senha -------------------------------------------
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextField(
                enabled: _alterarRede,
                controller: _controleSenha,
                decoration: InputDecoration(
                  hintText: (_controleSenha.text.isEmpty) ? _senha : _controleSenha.text,
                  icon: Icon(
                    Icons.lock
                  ),
                ),
              ),
            ),
                
            /// Botão de alteração do endereço
            Padding(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: MaterialButton(
                minWidth: 200,
                height: 60,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(_textoBotao),
                textColor: Colors.white,
                color: _alterarRede ? Colors.green : Colors.deepOrange,
                onPressed: (){
                  setState(() {
                    if(_textoBotao == 'Alterar Wi-Fi'){
                      _alterarRede = true;
                      _textoBotao = 'Confirmar';
                    }
                    else if (_textoBotao == 'Confirmar'){
                      _alterarRede = false;
                      _textoBotao = 'Alterar Wi-Fi';

                      print(_controleNome.text);
                      print(_controleSenha.text);
                      if(_controleNome.text.isEmpty || _controleSenha.text.isEmpty){
                        var wifiData = '';
                        TelaConfigBlueState().enviaWiFi(wifiData);
                      }
                      else{
                        var wifiData = '${_controleNome.text},${_controleSenha.text}';
                        TelaConfigBlueState().enviaWiFi(wifiData);
                      }
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Credenciais de rede enviadas.'
                          )
                        )
                      );
                    }
                  }
                );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}
