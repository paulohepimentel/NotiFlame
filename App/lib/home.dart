import 'package:flutter/material.dart';
import 'package:notiflame/estatisticas.dart';

/// Telas -> Navegação através da Bottom Navigation Bar
//import 'endereco.dart';
import 'sensores.dart';
import 'estatisticas.dart';
import 'configuracoes.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {

  int _currentIndex = 0;
  
  final List<Widget> _telas = [
    TelaEstatisticas(),
    //TelaInicial(),
    TelaSensores(),
    TelaConfig(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NotiFlame'),
      ),
      body:  IndexedStack(
        index: _currentIndex,
        children: _telas,
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        elevation: 15,
        items: <BottomNavigationBarItem>[
          /// Início
          BottomNavigationBarItem(
            title: Text('Dashboard'),
            icon: Icon(
              Icons.dashboard,
              color: Colors.deepOrange,
              size: 30
            ),
          ),
          /// Sensores
          BottomNavigationBarItem(
            title: Text('Sensores'),
            icon: Icon(
              Icons.settings_input_antenna,
              color: Colors.deepOrange,
              size: 30
            ),
          ),
          /// Configurações
          BottomNavigationBarItem(
            title: Text('Configurações'),
            icon: Icon(
              Icons.settings,
              color: Colors.deepOrange,
              size: 30
            ),
          ),
        ],
        selectedItemColor: Colors.deepOrange,
      ),
    );
  }
  
  void onTabTapped(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }
}