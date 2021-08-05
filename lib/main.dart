import 'package:flutter/material.dart';
import 'package:myproject/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home.dart';
import 'Control.dart';
import 'Statistic.dart';
import 'Warning.dart';
import 'Profile.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => Home(),
  //"/intro": (BuildContext context) => IntroScreen(),
};
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
AppBar buildAppBar(BuildContext context, Color kColor, Color arrColor) {
  return AppBar(
//bottomOpacity: 0.0,
    elevation: 0.0,
    backgroundColor: kColor,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: arrColor),
      onPressed: () => Navigator.of(context).pop(),
    ),
//title: Text("Sample"),
    centerTitle: true,
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreens(),
    );
  }
}
class BottomBar extends StatefulWidget {
  //const BottomBar({Key? key}) : super(key: key);
  int selectedIndex;
  BottomBar({this.selectedIndex});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article), title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_rounded), title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text(""),
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: widget.selectedIndex,
        selectedItemColor: Color(0xFF8E97FD),
        unselectedItemColor: Colors.grey,
        iconSize: 21,
        elevation: 5,
        onTap: (int index) {
          setState(() {
            widget.selectedIndex = index;
          });
          if (widget.selectedIndex == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Home()));
          }
          else if (widget.selectedIndex == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Control()));
          }
          else if (widget.selectedIndex == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Statistic()));
          }
          else if (widget.selectedIndex == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Warning()));
          }
          else if (widget.selectedIndex == 4) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Profile()));
          }
        },
    );
  }
}





