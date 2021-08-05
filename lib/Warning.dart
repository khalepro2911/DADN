import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'dart:math';


bool change = true;
class Warn {
  double temperature;
  double time;
  String gate;

  int countEast;
  int countWest;
  int countSouth;
  int countNorth;
  //constructor
  Warn({this.temperature, this.time, this.gate, this.countEast, this.countWest, this.countSouth, this.countNorth});

  @override
  String toString() {
    // TODO: implement toString
    return "Temperature: $temperature - Time of Holding Gate: $time - Gate: $gate";
  }
}

class Warning extends StatefulWidget {

  @override
  _WarningState createState() => _WarningState();
}

class _WarningState extends State<Warning> {

  // Hiển thị lên giao diện = snacbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Định nghĩa trạng thái cho List
  Warn _warn = Warn(temperature: num.parse((new Random().nextDouble()*(44 - 36) + 36).toStringAsFixed(2)), time: num.parse((new Random().nextDouble()*(999.99 - 1) + 1).toStringAsFixed(2)), gate: "EAST GATE", countEast: 0, countWest: 0, countSouth: 0, countNorth: 0);
  List<Warn> _warns = <Warn>[];

  showPleaseInsertAgain(BuildContext context) {
    // Create button
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          titlePadding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              const Text('Warning Statistic', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            ],
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.table_chart, color: Colors.green),
                  SizedBox(width: 10),
                  Text("East gate:   ${_warn.countEast}"),
                ],
              ),
            ),
            SimpleDialogOption(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.bubble_chart, color: Colors.green),
                  SizedBox(width: 10),
                  Text("West gate:  ${_warn.countWest}"),
                ],
              ),
            ),
            SimpleDialogOption(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.pie_chart, color: Colors.green),
                  SizedBox(width: 10),
                  Text("South gate: ${_warn.countSouth}"),
                ],
              ),
            ),
            SimpleDialogOption(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.stacked_line_chart, color: Colors.green),
                  SizedBox(width: 10),
                  Text("North gate: ${_warn.countNorth}"),
                ],
              ),
            ),
            SimpleDialogOption(
              child: Text("OK",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.green,
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
  List<Widget> buildWarning(){
    return _warns.map((eachWarn){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Container(
              width: 105,
              //color: (eachWarn.temperature >= 38) ? Colors.red[200] : Color(0xFFD0E6A5),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Colors.red : Colors.green,
                ),
                child: Column(
                  children: [
                    Icon(
                      (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Icons.dangerous : Icons.verified_user,//Icons.security_outlined,
                      color: (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text((eachWarn.temperature >= 38 || eachWarn.time >= 600) ? "Warning" : "Safety"),
                  ],
                ),
              ),
            ),
            Container(
              width: 240,
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Colors.deepOrange[200] : Color(0xFFD0E6A5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Colors.white : Colors.black87,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      eachWarn.gate,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: (eachWarn.temperature >= 38 || eachWarn.time >= 600) ? Colors.red : Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text("1st floor, A Building"),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.thermostat_outlined,
                          color: (eachWarn.temperature >= 38) ? Colors.red : Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text("Temperature: ${eachWarn.temperature}"),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          (eachWarn.time >= 600) ? Icons.alarm_off_outlined : Icons.alarm_on_outlined,
                          color: (eachWarn.time >= 600) ? Colors.red : Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text("Time of holding gate: ${eachWarn.time} (s)"),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            "Warning",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        backgroundColor: Color(0xFFD0E6A5),
        //backgroundColor: Color(0xFFFA897B),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
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
                      //selectionColor: Color(0xFF802E5D),
                      //selectionColor: Color(0xFFC68EAD),
                      selectionColor: Colors.green,
                      selectedTextColor: Colors.white,
                      activeDates: [
                        DateTime.now(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: change == true ? Colors.green: Colors.red,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.addchart),
                        //icon: Icon(Icons.graphic_eq_rounded),
                        onPressed:() =>showPleaseInsertAgain(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 100),
                  FlatButton(
                    child: Text(
                      "In/Out",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: (){
                      setState(() {
                        _warns.insert(0, _warn);

                        // điều kiện random tên cổng
                        if (1 + new Random().nextInt(3) == 1) _warn.gate = "EAST GATE";
                        else if (1 + new Random().nextInt(3) == 2) _warn.gate = "WEST GATE";
                        else if (1 + new Random().nextInt(3) == 3) _warn.gate = "SOUTH GATE";
                        else  _warn.gate = "NORTH GATE";

                        // điều kiện thiết lập bảng thống kê warning
                        if (_warn.temperature >= 38 || _warn.time >= 600){
                          change = false;
                          if (_warn.gate == "EAST GATE")  _warn.countEast++;
                          else if (_warn.gate == "WEST GATE")  _warn.countWest++;
                          else if (_warn.gate == "SOUTH GATE")  _warn.countSouth++;
                          else _warn.countNorth++;
                        }
                        else change = true;

                        // Hiển thị thông báo SnackBar
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text( change == false ? "Warning:"+_warn.toString(): "Safety", ),
                            duration: Duration(seconds: 3),
                          ),
                        );

                        // truyền giá trị ban đầu cho các tham số trong class Warn
                        _warn = Warn(
                          temperature: num.parse((new Random().nextDouble()*(44 - 36) + 36).toStringAsFixed(2)),
                          time: num.parse((new Random().nextDouble()*(999.99 - 1) + 1).toStringAsFixed(2)),
                          countEast: _warn.countEast,
                          countWest: _warn.countWest,
                          countSouth: _warn.countSouth,
                          countNorth: _warn.countNorth,
                        );
                      });
                    },
                  ),
                  //Text((_warn.temperature >= 38 || _warn.time >= 600)?"Warning: ${_warn.count++}" : "Warning: ${_warn.count}"),
                ],
              ),
            ),
            Column(
              children: buildWarning(),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BottomBar(selectedIndex: 3),
    );
  }
}



