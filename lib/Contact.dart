import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  int index = 0;
  //MyAlert _yc = MyAlert();
  Container buildBox(Color color, String title, String content/*, Function func*/){
    index++;
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
          onPressed: null, //func(),
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Divider(),
              Row(
                children: [
                  if (index%3 == 1) Icon(Icons.phone_outlined, color: Colors.white,)
                  else if (index%3 == 2) Icon(Icons.mail_outlined, color: Colors.white,)
                  else if (index%3 == 0)Icon(Icons.location_on_outlined, color: Colors.white,),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 70, bottom: 10),
            child: buildBox(Colors.deepPurpleAccent, 'Phone number','  Hotline: 1900 2021'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: buildBox(Colors.deepPurpleAccent, 'Email', '  Email: cares@is.com'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: buildBox(Colors.deepPurpleAccent, 'Office', '  Location: Linh Trung, Thu Duc City'),
          ),
        ],
      ),
    );
  }
}
