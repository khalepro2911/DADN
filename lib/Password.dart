import 'package:flutter/material.dart';
import 'Profile.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var _formKey = GlobalKey<FormState>();
  final nameRegExp = RegExp('[a-zA-Z]');
  bool _passwordVisible;
  //var  = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  Padding buildPassword(String title, String hint){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        //decoration: InputDecoration(labelText: 'Password'),
        //key: _formKey,
        keyboardType: TextInputType.emailAddress,
        //onFieldSubmitted: (value) {},

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a valid password!';
          } else if (value.length < 6)
            return 'Should be at least 6';
          else if (value.length > 50) return 'Should be at most 50';
          return null;
        },
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(_passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: (){
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                )),
            labelText: title,
            hintText: hint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                    child: Text(
                      'Please enter these field below',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  // old pass
                  buildPassword("Old password", 'Enter your old password'),
                  Divider(),
                  // new pass
                  buildPassword("New password", 'Enter your new password'),
                  Divider(),
                  buildPassword("Check your new password", 'Re-enter your new password'),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) editPassword(context);
                        //_formKeyEmail.currentState.save();
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  editPassword(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Password"),
      content: Text("Do you want to change your password ?"),
      actions: <Widget>[
        FlatButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
          },
        ),
        FlatButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
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
}
