import 'package:flutter/material.dart';
import 'package:myproject/main.dart';
import 'SignIn.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //var _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayName = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  void addUser(){
    firestoreInstance.collection("user").add(
      {
        "name": _displayName.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
      }
    ).then((value){
      print("ahihi: ${value.id}");
    });
  }

  final nameRegExp = RegExp('[a-zA-Z]');
  final phoneRegExp = RegExp(r"^\+?0[0-9]{9}$");
  bool _passwordVisible;
  //var  = GlobalKey<FormState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, Colors.white, Colors.black),
      backgroundColor: Colors.white,

      /*appBar: AppBar(
        title: Text(
          'Chào mừng bạn trở lại',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: Nunito,
          ),
        ),
        backgroundColor: Colors.white,
      ),*/
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Tạo tài khoản của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    //key: _formKeyEmail,
                    //onFieldSubmitted: (value){},
                    controller: _displayName,
                    validator: (value) => value.isEmpty
                        ? 'Enter Your Name'
                        : (nameRegExp.hasMatch(value)
                        ? null
                        : 'Enter a Valid Name'),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          )),
                      labelText: 'Name',
                      hintText: 'Enter valid name as Kha',
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    //key: _formKeyEmail,
                    //onFieldSubmitted: (value){},
                    controller: _phoneController,
                    validator: (value) => value.isEmpty
                        ? 'Enter Your Phone Number'
                        : (phoneRegExp.hasMatch(value)
                        ? null
                        : 'Enter a Valid Phone Number'),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          )),
                      labelText: 'Phone number',
                      hintText: 'Enter valid name as 0987654321',
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    //key: _formKeyEmail,
                    //onFieldSubmitted: (value){},
                    controller: _emailController,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !EmailValidator.validate(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    }, //Validator

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          )),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com',
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    //decoration: InputDecoration(labelText: 'Password'),
                    //key: _formKey,
                    controller: _passwordController,
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
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    //decoration: InputDecoration(labelText: 'Password'),
                    //key: _formKey,
                    keyboardType: TextInputType.emailAddress,
                    //onFieldSubmitted: (value) {},
                    //obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a valid password!';
                      } else if (value.length < 6)
                        return 'Should be at least 6';
                      else if (value.length > 50) return 'Should be at most 50';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            )),
                        labelText: 'Re-enter password',
                        hintText: 'Enter secure password'),
                  ),
                ),
                Divider(),
                Container(
                  height: 63,
                  width: 374,
                  decoration: BoxDecoration(
                      color: Color(0xFF8E97FD),
                      borderRadius: BorderRadius.circular(40)),
                  child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _registerAccount();
                      }
                      //_formKeyEmail.currentState.save();
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerAccount() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text))
        .user;
    if (user != null){
      if (!user.emailVerified){
        await user.sendEmailVerification();
        addUser();
        //emailSignIn = userIdSignUp;
      }
      await user.updateProfile(displayName: _displayName.text);
      //final user1 = _auth.currentUser;
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => SignIn()));
    }

  }
}
