import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  //const ({Key? key}) : super(key: key);
  final TabController tabController;
  Home({this.tabController});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//class Home extends StatelessWidget {

  final String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  Container buildBox(BuildContext context, Color color, String title, String content, int index/*, Function func*/){
    return Container(
      //alignment: Alignment.centerLeft,
      width: 374,
      height: 95,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FlatButton(
        //color: Color(0xFFFA897B),
          onPressed: (){
            if (index == 1) {
              widget.tabController.animateTo(index);
              //Navigator.push(
                  //context, MaterialPageRoute(builder: (_) => Control()));
            }
            else if (index == 2) {
              widget.tabController.animateTo(index);
              //Navigator.push(
                 // context, MaterialPageRoute(builder: (_) => Statistic()));
            }
            else if (index == 3) {
              widget.tabController.animateTo(index);
              //Navigator.push(
                  //context, MaterialPageRoute(builder: (_) => Warning()));
            }
            else if (index == 4) {
              widget.tabController.animateTo(index);
              //Navigator.push(
                  //context, MaterialPageRoute(builder: (_) => Profile()));
            }
          }, //func(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                ),
              ),
              Divider(),
              Text(
                content,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5A6175),
                ),
              ),
            ],
          )

      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    //bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 19),
            child: Text(
              'Welcome to IS',
              style: TextStyle(
                color: Color(0xFF3F414E),
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Text(
              now,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFFA1A4B2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19,vertical: 15),
            child: buildBox(context, Color(0xFFFA897B), 'Control', 'STATE AND LIST OF GATE', 1),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:19,vertical:15),
            child: buildBox(context, Color(0xFFFFDD94), 'Statistic', 'TIME(S) OF VISITOR(S) IN/OUT', 2),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:19.0,vertical: 15),
            child: buildBox(context, Color(0xFFD0E6A5),'Warning', 'WARNING(S): TEMPERATURE AND TIME OF HOLDING GATE', 3),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:19,horizontal: 15),
            child: buildBox(context, Color(0xFF8E97FD), 'Profile','YOUR INFORMATION', 4),
          ),
        ],
      ),
      //bottomNavigationBar: BottomBar(selectedIndex: 0),
    );
  }
}
