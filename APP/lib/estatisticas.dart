import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TelaEstatisticas extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => TelaEstatisticasState();
}

class Historico {
  final String ano;
  final int modulo;
  final charts.Color color;

  Historico(this.ano, this.modulo, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
    );
}

class Mensal {
  final String ano;
  final int modulo;
  final charts.Color color;

  Mensal(this.ano, this.modulo, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
    );
}

class TelaEstatisticasState extends State<TelaEstatisticas> {

  double chamas, gas, alarme, modulo;

  Material dashSensores(String titulo, String numero, Color cor){
    return Material(
      color: Colors.white,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(15.0),
      shadowColor: Colors.grey[100],
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[
                // Título
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Text(
                    titulo,
                    style:TextStyle(
                      fontSize: 15.0,
                      color: cor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                // String de Dados
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Ativado ",
                        style:TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        numero,
                        style:TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        " vezes!",
                        style:TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ]
                  ),
                ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('ESP32').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            );
          }
          else{
            
            //! HISTÓRICO ANUL
            var data0 = [
              new Historico('2016', 12, Colors.amber),
              new Historico('2017', 42, Colors.amber),
              new Historico('2018', 35, Colors.amber),
              new Historico('2019', ( snapshot.data.documents[0]['chamas'] +
                                      snapshot.data.documents[0]['gas'] +
                                      snapshot.data.documents[0]['modulo']
                                    ), Colors.orange),
            ];
            var series0 = [
              new charts.Series(
                domainFn: (Historico moduloData, _) => moduloData.ano,
                measureFn: (Historico moduloData, _) => moduloData.modulo,
                colorFn: (Historico moduloData, _) => moduloData.color,
                id: 'Historico Anual',
                data: data0,
              ),
            ];
            var chart0 = new charts.BarChart(
              series0,
              animate: true,
            );
            var chartBar = new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new SizedBox(
                height: 150.0,
                child: chart0,
              ),
            );

            //! HISTÓRICO MENSAL
            var data1 = [
              new Mensal('0', snapshot.data.documents[0]['chamas'], Colors.red),
              new Mensal('1', snapshot.data.documents[0]['gas'], Colors.blue),
              new Mensal('2', snapshot.data.documents[0]['modulo'], Colors.green),
            ];
            var series1 = [
              new charts.Series(
                domainFn: (Mensal moduloData, _) => moduloData.ano,
                measureFn: (Mensal moduloData, _) => moduloData.modulo,
                colorFn: (Mensal moduloData, _) => moduloData.color,
                id: 'Historico Mensal',
                data: data1,
              ),
            ];
            var chart1 = new charts.PieChart(
              series1,
              animate: true,
            );
            var chartPizza = new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new SizedBox(
                height: 150.0,
                child: chart1,
              ),
            );

            return Container(
              color:Colors.grey[300],
              child:StaggeredGridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.only(right:8.0, left:8.0, top: 8.0),
                    child: Material(
                      color: Colors.white,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
                      shadowColor: Colors.grey[100],
                      child: 
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Text(
                                "Histórico do sistema: 2019", 
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            chartBar 
                          ],
                        ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Material(
                      color: Colors.white,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
                      shadowColor: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Text(
                              "Total Mensal",
                              style:TextStyle(
                                fontSize: 20.0,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Text(
                              ("Novembro"+": "+
                                ( snapshot.data.documents[0]['chamas'] +
                                  snapshot.data.documents[0]['gas'] +
                                  snapshot.data.documents[0]['modulo']
                                ).toString()),
                              style:TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                          chartPizza
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: dashSensores(
                      "Sensor de Chamas",
                      snapshot.data.documents[0]['chamas'].toString(),
                      Colors.red,
                    ),
                  ),
                    
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: dashSensores(
                      "Sensor de Gás",
                      snapshot.data.documents[0]['gas'].toString(),
                      Colors.blue,
                    ),
                  ),
                    
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: dashSensores(
                      "Alarme Físico",
                      snapshot.data.documents[0]['modulo'].toString(),
                      Colors.green,
                    ),
                  ),
                    
                ],
                staggeredTiles: [
                  // Gráfico de linha
                  StaggeredTile.extent(4, 220.0),
                  // Gráfico círcular 
                  StaggeredTile.extent(2, 240.0),
                  // Sensores
                  StaggeredTile.extent(2, 72.0),
                  StaggeredTile.extent(2, 72.0),
                  StaggeredTile.extent(2, 72.0),
                ],
              ),
          );
          }
        }
      ),
    );
  }
}