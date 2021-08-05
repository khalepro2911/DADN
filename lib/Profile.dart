import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'EditAccount.dart';
import 'Contact.dart';
import 'Password.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          //appBar: buildAppBar(context),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.perm_contact_cal_rounded), text: "Account"),
                Tab(icon: Icon(Icons.vpn_key_rounded), text: "Password",),
                Tab(icon: Icon(Icons.phone_rounded), text: "About Us",),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            toolbarHeight: 100,
            title: Align(
              child: Text(
                "Profile", //${_yc.require}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            backgroundColor: Color(0xFF8E97FD),
          ),
          body: TabBarView (
            children: [
              EditAccount(),
              Password(),
              Contact(),
            ],
          ),
          //bottomNavigationBar: BottomBar(selectedIndex: 4),
        )
    );
  }
}