import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:myproject/Server/Const.dart';
import 'dart:math';

import 'Server/Adafruit_feed.dart';
import 'Server/mqtt_stream.dart';



class Statistic extends StatefulWidget {
  //const Statictis({Key? key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  _StatisticState(){
    infraredMqtt = AppMqttTransactions();
    countSen1 = 0;
    countSen2 = 0;
  }
  AppMqttTransactions infraredMqtt;
  String subscriptionInfo;
  String subscriptionData;
  int countSen1 = 0;
  int countSen2 = 0;
  void subscribe(String topic) {
    infraredMqtt.subscribe(topic);

  }
  void _fetchJson(String jsonData){
    var parsedJson = json.decode(jsonData);
    var data = parsedJson['data'];
    if(data[0] == '1'){
      countSen1++;
    }
    if(data[1] == '1'){
      countSen2++;
    }
    //return (data == '1') ? true : false;

  }


  @override
  Widget build(BuildContext context) {
    subscribe(topicInfrared);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        toolbarHeight: 100,
        title: Align(
          child: Text(
            "Statistic",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        backgroundColor: Color(0xFFFFDD94),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              //color: Colors.blueGrey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: DatePicker(
                      DateTime.now().add(Duration(days: -3)),
                      width: 45,
                      height: 80,
                      //controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.green,
                      //selectionColor: Color(0xFF6C7CAC),
                      selectedTextColor: Colors.white,
                      activeDates: [
                        DateTime.now(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: AdafruitFeed.sensorStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading...');
                        }
                        else{
                          subscriptionInfo = snapshot.data;
                          _fetchJson(subscriptionInfo);
                          return Text('In: $countSen1, Out: $countSen2');

                        }
                      }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 25),
                      Text(
                        'State',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 100,),
                      Text(
                        'List of Gate',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  BuildLog(
                      context: context,
                      gate: "EAST GATE",
                      isDot: new Random().nextBool(),
                  ),
                  Divider(),
                  BuildLog(
                      context: context,
                      gate: "WEST GATE",
                      isDot: new Random().nextBool(),
                  ),
                  Divider(),
                  BuildLog(
                    context: context,
                    gate: "SOUTH GATE",
                    isDot: new Random().nextBool(),
                  ),
                  Divider(),
                  BuildLog(
                    context: context,
                    gate: "NORTH GATE",
                    isDot: new Random().nextBool(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BottomBar(selectedIndex: 2),
    );
  }
}

class BuildLog extends StatelessWidget {
  BuildLog({this.context, this.gate, this.isDot});

  BuildContext context;
  String gate;
  bool isDot;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Container(
          //padding: EdgeInsets.only(left: 5),
          width: 105,
          child: DefaultTextStyle(
            style: TextStyle(
              color: isDot ? Colors.black87 : Colors.black12,
            ),
            child: Column (
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      //color: (isDot == true) ? Color(0xFFFFDD94) : Colors.black12,
                      color: (isDot == true) ? Colors.green : Colors.black12,
                    ),
                    SizedBox(width: 10),
                    Text(isDot == true ? "Active" : "Non Active"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.open_in_full_outlined,
                      color: (isDot == true) ? Colors.black : Colors.black12,
                    ),
                    SizedBox(width: 10),
                    Text(
                      //(isDot == true) ? DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: (output<input) ? -input : -101))).toString() : "0",
                      (isDot == true) ? DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(new Random().nextInt(19))))).toString() : "0",
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.close_fullscreen_outlined,
                      color: (isDot == true) ? Colors.black : Colors.black12,
                    ),
                    SizedBox(width: 10),
                    Text(
                      (isDot == true) ? DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(20+new Random().nextInt(100))))).toString() : "0",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          height: 130,
          width: 215,
          //padding: EdgeInsets.only(left: 5.0),
          decoration: BoxDecoration(
            color: isDot ? Color(0xFFFFDD94) : Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FlatButton(
            onPressed:(){
              isDot ? showDiary(context) : null;
            },
            child: DefaultTextStyle(
              style: TextStyle(
                color: isDot ? Colors.black87 : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    gate,
                    style: TextStyle(
                      fontSize: 20,
                      //backgroundColor: Colors.blueAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: isDot ? Colors.black87 : Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          isDot ?
                            "average time: ${num.parse((new Random().nextDouble()*(1000 - 1) + 1).toStringAsFixed(2))}(s)"
                              :
                              "average time: 0(s)"
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.login_outlined,
                          color: isDot ? Colors.black87 : Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(isDot ? "${new Random().nextInt(100)} time(s) visitor(s) in" : "0 time(s) visitor(s) in"),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: isDot ? Colors.black87 : Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(isDot ? "${new Random().nextInt(100)} time(s) visitor(s) out" : "0 time(s) visitor(s) out"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  showDiary(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Open/Close Gate Diary'),
          children: <Widget>[
            SimpleDialogOption(
              //child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -output)))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -input)))}'),
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(20 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(100 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(120 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(200 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(220 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(300 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(320 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(400 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(420 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(500 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(520 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(600 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(620 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(700 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(720 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(800 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(820 + new Random().nextInt(80)))))}'),
            ),
            SimpleDialogOption(
              child: Text('Close: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(900 + new Random().nextInt(19)))))} - Open: ${DateFormat("hh-mm-ss").format(DateTime.now().add(Duration(seconds: -(920 + new Random().nextInt(100)))))}'),
            ),
            SimpleDialogOption(
              child: Text("OK",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

