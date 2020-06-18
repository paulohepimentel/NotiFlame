import 'package:flutter/material.dart';
import 'config_blue.dart';

class TelaSensores extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => TelaSensoresState();
}

class TelaSensoresState extends State<TelaSensores> {

  String _textoChama = 'Desativado';
  String _textoGas = 'Desativado';
  String _textoAlarme = 'Desativado';

  bool _estadoChama = false;
  bool _estadoGas = false;
  bool _estadoAlarme = false;

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         
          /// Sensor de Chamas ---------------------------
          // Título do Sensor
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Center(
              child: Text("Sensor de Chama", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                )
              )
            ),
          ),
          // Imagem | Botão
          Padding(
            padding: EdgeInsets.all(10.0),  
            child: Row(
              children: <Widget> [
                Expanded(
                  child: Text(" 🙈 "/*🔥*/,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 60)
                  )
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: Colors.deepOrange
                  )
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 2,
                    height: 80,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(_textoChama, style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: _estadoChama ? Colors.green : Colors.grey,
                    onPressed: (){
                      setState(() {
                        _estadoChama = !_estadoChama;
                        if(_estadoChama){
                          _textoChama = 'Ativado';
                          TelaConfigBlueState().estadoSensor(11);
                        }
                        else if (!_estadoChama){
                          _textoChama = 'Desativado';
                          TelaConfigBlueState().estadoSensor(10);
                        }
                      });
                    },                      
                  )
                ),
              ]
            )
          ),
          
          /// Sensor de Gás -----------------------------
          // Título do Sensor
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text("Sensor de Gás",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              )
            ),
          ),
          // Imagem | Botão
          Padding(
            padding: EdgeInsets.all(15.0),  
            child: Row(
              children: <Widget> [
                Expanded(
                  child: Text(" 🙊 "/*🌫️*/,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 60)
                  )
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: Colors.deepOrange
                  )
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 2,
                    height: 80,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(_textoGas, style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: _estadoGas ? Colors.green : Colors.grey,
                    onPressed: (){
                      setState(() {
                        _estadoGas = !_estadoGas;
                        if(_estadoGas){
                          _textoGas = 'Ativado';
                          TelaConfigBlueState().estadoSensor(21);
                        }
                        else if (!_estadoGas){
                          _textoGas = 'Desativado';
                          TelaConfigBlueState().estadoSensor(20);
                        }
                      });
                    },                    
                  )
                ),
              ]
            )
          ),
          
          /// Alarme -----------------------------------
          // Título do Sensor
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Text("Alarme Físico",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
              )
            ),
          ),
          // Imagem | Botão
          Padding(
            padding: EdgeInsets.all(10.0),  
            child: Row(
              children: <Widget> [
                Expanded(
                  child: Text(" ️️🙉 "/*🔊️*/,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 60)
                  )
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: Colors.deepOrange
                  )
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 2,
                    height: 80,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(_textoAlarme, style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: _estadoAlarme ? Colors.green : Colors.grey,
                    onPressed: (){
                      setState(() {
                        _estadoAlarme = !_estadoAlarme;
                        if(_estadoAlarme){
                          _textoAlarme = 'Ativado';
                          TelaConfigBlueState().estadoSensor(31);
                        }
                        else if (!_estadoAlarme){
                          _textoAlarme = 'Desativado';
                          TelaConfigBlueState().estadoSensor(30);
                        }
                      });
                    },
                  ),
                ),
              ]
            )
          ),
        ]
      )
    );
  }
}