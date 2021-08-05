import 'package:flutter/material.dart';
import 'Home.dart';
import 'Warning.dart';
import 'Profile.dart';
import 'Control.dart';
import 'Statistic.dart';


const kMainColor = Color(0xFF8E97FD);
class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
class ControlTab extends StatefulWidget {
  //ControlTab({Key key}) : super(key: key);
  final TabController tabController;
  ControlTab({this.tabController});
  _ControlTabState createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> with SingleTickerProviderStateMixin {
  onButtonClick(){
    widget.tabController.animateTo(1); //index is the index of the page your are intending to (open. 1 for page2)
  }
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        //appBar: buildAppBar(context),
        body: TabBarView(
          controller: _tabController,
          children: [
            Home(tabController: _tabController,),
            Control(),
            Statistic(),
            Warning(),
            Profile(),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: new TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home),),
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.trending_up)),
              Tab(icon: Icon(Icons.warning_rounded)),
              Tab(icon: Icon(Icons.person)),
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: Color(0xFF8E97FD),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: CircleTabIndicator(color: kMainColor, radius: 3),
            /*UnderlineTabIndicator(
              insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 47.0),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
            ),*/
            labelPadding: EdgeInsets.only(right: 0.0, left: 0.0),
          ),
        ),
      ),
    );
  }
}
