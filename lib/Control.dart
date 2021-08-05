import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'Server/Adafruit_feed.dart';
import 'Server/Const.dart';
import 'Server/mqtt_stream.dart';


class AppStore with ChangeNotifier {


  bool _isActive1 = true;
  bool _isActive2 = true;
  bool _isActive3 = true;
  bool _isActive4 = true;

  bool get isActive1 => _isActive1;
  bool get isActive2 => _isActive2;
  bool get isActive3 => _isActive3;
  bool get isActive4 => _isActive4;

  set isActive1(bool value) {
    _isActive1 = value;
    notifyListeners();
  }

  set isActive2(bool value) {
    _isActive2 = value;
    notifyListeners();
  }

  set isActive3(bool value) {
    _isActive3 = value;
    notifyListeners();
  }

  set isActive4(bool value) {
    _isActive4 = value;
    notifyListeners();
  }
}
class Control extends StatefulWidget {
  //const Control({Key? key}) : super(key: key);


  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  //variable to control server
    _ControlState(){
      switchMqtt = AppMqttTransactions();
      switchMqtt.topicName = topicSwitch;    }

  //String publishSwitchOnData;
  //String publishSwitchOffData;
  String subscriptionInfo;
  bool subscriptionData;
  AppMqttTransactions switchMqtt;


  void subscribe(String topic) {
    switchMqtt.subscribe(topic);

  }

  void publish(String topic, String value) {
    switchMqtt.publish(topic, value);
  }

  bool _fetchJson(String jsonData){
    var parsedJson = json.decode(jsonData);
    var data = parsedJson['data'];
    return (data == '1') ? true : false;

  }

  DefaultTextStyle buildNode(bool isActive, String gate, String location, String person, String phone){
    return DefaultTextStyle(
      style: TextStyle(
          color: isActive ? Colors.black87 : Colors.white
      ),
      child: Expanded(
        child: Container( // Container image 1
          //width: 125,
          height: 130,
          padding: EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            //border: Border.all(width: 10.0, color: Color(0xFFFA897B)),
            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
            color: isActive ? Color(0xFFFA897B) : Colors.black12,
          ),
          margin: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
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
                      Icons.location_on_outlined,
                      color: isActive ? Colors.black87 : Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(location),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      color: isActive ? Colors.black87 : Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(person),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      color: isActive ? Colors.black87 : Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(phone),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //subscribe(topicSwitch);
    publish(topicSwitch, publishSwitchOnData);
    return ChangeNotifierProvider(
      create: (_) => AppStore(),
      child: Scaffold(
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
              "Control",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
          backgroundColor: Color(0xFFFA897B),
        ),

        body: Consumer<AppStore>(
            builder: (context, store, child){
              return Container(
                child: ListView(
                  children: <Widget>[
                    MyAlert(),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 35),
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
                          Row(
                            children: <Widget>[
                              StreamBuilder(
                                stream: AdafruitFeed.sensorStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text('Loading...');
                                  }
                                  else{
                                    subscriptionInfo = snapshot.data;
                                    subscriptionData = _fetchJson(subscriptionInfo);
                                    return MySwitch(
                                        value: subscriptionData,//store.isActive1,
                                        onChanged: (value) {
                                          store.isActive1 = value;
                                          publish(topicSwitch, value ? publishSwitchOnData : publishSwitchOffData);

                                        });

                                }
                              }),
                              //MySwitch(value: store.isActive1, onChanged: (value) { store.isActive1 = value; }),
                              SizedBox(width: 5),
                              buildNode(store.isActive1, "EAST GATE", "1st floor, A Building", "Ngo Minh Hanh", "0123456789")
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              MySwitch(value: store.isActive2, onChanged: (value) { store.isActive2 = value; }),
                              SizedBox(width: 5),
                              buildNode(store.isActive2, "WEST GATE", "1st floor, A Building", "Le Kha", "0123456789")
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              MySwitch(value: store.isActive3, onChanged: (value) { store.isActive3 = value; }),
                              SizedBox(width: 5),
                              buildNode(store.isActive3, "SOUTH GATE", "1st floor, A Building", "Nguyen Duy Son", "0123456789")
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              MySwitch(value: store.isActive4, onChanged: (value) { store.isActive4 = value; }),
                              SizedBox(width: 5),
                              buildNode(store.isActive4, "NORTH GATE", "1st floor, A Building", "Mai Dinh Phuc", "0123456789")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        //bottomNavigationBar: BottomBar(selectedIndex: 1),
      ),
    );
  }
}
// Switch active time





//Switch

class MySwitch extends StatefulWidget {
  final bool value;
  final void Function(bool) onChanged;

  MySwitch({this.value, this.onChanged});

  @override
  _MySwitch createState() => _MySwitch();
}

class _MySwitch extends State<MySwitch> {
  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;
  //bool isActive = false;

  Timer timer;

  void handleTick() {
    if (widget.value) {
      if(this.mounted){
        setState(() {
          !widget.value;
          secondsPassed = secondsPassed + 1;
        });
      }

    }
    else {
      setState(() {
        setState(() {
          !widget.value;
          secondsPassed = 0;
        });
      });
    }
  }
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);
    return Container(
      child: Column(
        children: <Widget>[
          Switch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeTrackColor: Color(0xFFFA897B),
            activeColor: Colors.red,
            inactiveTrackColor: Colors.black12,
            inactiveThumbColor: Colors.blueGrey,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.access_time_outlined,
                color: widget.value ? Color(0xFFFA897B) : Colors.black12,
              ),
              SizedBox(width: 5),
              Text(widget.value ? 'Active Time' : 'Non Active'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LabelText(
                  label: 'HRS',
                  value: hours.toString().padLeft(2, '0'), onoff: widget.value),
              LabelText(
                  label: 'MIN',
                  value: minutes.toString().padLeft(2, '0'), onoff: widget.value),
              LabelText(
                  label: 'SEC',
                  value: seconds.toString().padLeft(2, '0'), onoff: widget.value),
            ],
          ),
        ],
      ),
    );
  }
}
class LabelText extends StatelessWidget {
  LabelText({this.label, this.value, this.onoff});

  final String label;
  final String value;
  final bool onoff;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        //color: Colors.teal,
        color: onoff?  Color(0xFFFA897B) : Colors.black12 ,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: onoff? Colors.black : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: onoff? Colors.black : Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
// MyAlert
class MyAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 280, top: 20),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Color(0xFFFA897B),
                shape: CircleBorder(),
              ),
              child: IconButton(
                //padding: EdgeInsets.only(left:341),
                color: Colors.black,
                icon: const Icon(Icons.add),
                onPressed: (){
                  showAlertDialog(context);
                  print("có 1 yêu cầu cần dc xử lý");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thank for using my service"),
    content: Text("We will contact you early!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
