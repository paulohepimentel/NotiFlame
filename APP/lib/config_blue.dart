import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter_blue/flutter_blue.dart';

class TelaConfigBlue extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => TelaConfigBlueState();
}

class TelaConfigBlueState extends State<TelaConfigBlue> {

  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static BluetoothDevice device;
  static BluetoothCharacteristic char1;
  static BluetoothCharacteristic char2;
  
  int estado = 0;
  bool botao = false;
  
  bool loading = false;
  bool reading = false;

  void initState() {
    super.initState();
  }

  void scanConnect() {
    if (loading){
      return;
    }
    loading = true;
    flutterBlue.startScan(
      scanMode: ScanMode.balanced,
      timeout: Duration(seconds: 10)
    );
    Timer(Duration(seconds: 10), () => loading = false);
  }

  void findCharacteristics() async {
    
    List <BluetoothService> services = await device.discoverServices();
    BluetoothCharacteristic blueChar;
    var characteristics;

    services.forEach((service) async {
      characteristics = service.characteristics;
      for (blueChar in characteristics) {
        if (blueChar.uuid.toString() == '560d029d-57a1-4ccc-8868-9e4b4ef41da6') {
          print(blueChar.uuid.toString());
          setState(() {
            char1 = blueChar;
          });
        }
        else if (blueChar.uuid.toString() == 'db433ed3-1e84-49d9-b287-487440e7137c') {
          print(blueChar.uuid.toString());
          blueChar.write([16], withoutResponse: true);
          setState(() {
            char2 = blueChar;
          });
        }
      }
    });
  }

  Future<void> showList() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione o módulo'),
          content: SingleChildScrollView(
            child: StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data.map((r) {
                  return ListTile(
                    title: Text(r.device.name),
                    subtitle: Text(r.device.id.toString()),
                    onTap: () {
                      if (device != null) {
                        device.disconnect();
                        device = null;
                        char1 = null;
                        char2 = null;
                      }
                      r.device.connect();
                      setState(() {
                        device = r.device;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                if (device != null){
                  findCharacteristics();
                }
              },
            ),
          ],
        );
      }
    );
  }

  void estadoSensor(int message) async { 
    /// Chama:  Ligado: 11    Desligado: 10
    /// Gás:    Ligado: 21    Desligado: 20
    /// Buzzer: Ligado: 31    Desligado: 30
    if (char1 != null) {
      char1.write([message], withoutResponse: true);
    }
  }

  void enviaWiFi(String data) async {
    if (char1 != null){
      await char1.write(utf8.encode(data), withoutResponse: true);
    }
  }

  @override
  Widget build(BuildContext context) {    
    return Container(
      child: Column (
        children: [

          // Título e explicação
          Container(
            //margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom:30),
            child: Text(
              'Ative o sinal Bluetooth do smartphone e em seguida clique no botão abaixo para buscar e se conectar ao módulo ESP32',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          
          /// Botão Bluetooth
          Padding(
            padding: EdgeInsets.only(left: 60, right: 60, bottom: 10, top: 10),
            child: MaterialButton(
              minWidth: 200,
              height: 60,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text('Buscar Dispositivo'),
              textColor: Colors.white,
              color: Colors.deepOrange,
              onPressed: (){
                scanConnect();
                showList();
              },
            ),
          ),

          // Detalhes da Coneção
          Container(
            child: (device == null) ? null : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (char2 == null)
              ? <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  child: Icon(
                    Icons.bluetooth_disabled,
                    size: 60.0,
                    color: Colors.red,
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Nenhuma conexão estabelecida!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
              : <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  child: Icon(
                    Icons.bluetooth_connected,
                    size: 60.0,
                    color: Colors.blue,
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Conexão estabelecida com sucesso!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}