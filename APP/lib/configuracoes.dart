import 'package:flutter/material.dart';
import 'config_blue.dart';
import 'config_wifi.dart';

class TelaConfig extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => TelaConfigState();
}

class TelaConfigState extends State<TelaConfig>  with SingleTickerProviderStateMixin{

  TabController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          icon: Icon(Icons.bluetooth, color: Colors.deepOrange),
        ),
        Tab(
          icon: Icon(Icons.wifi, color: Colors.deepOrange),
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Configuração das Conexões',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        bottom: getTabBar(),
        backgroundColor: Colors.white
      ),
      
      body: getTabBarView(<Widget>[
        TelaConfigBlue(), 
        TelaConfigWiFi()
      ])
    );
  }
}