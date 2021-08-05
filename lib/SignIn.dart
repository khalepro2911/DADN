import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'ControlTab.dart';
import 'package:email_validator/email_validator.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//String userDocumentId;

class SignIn extends StatefulWidget {
  static String userDocumentId;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Google sign in
  GoogleSignIn googleAuth = new GoogleSignIn();

  //var  = GlobalKey<FormState>();
  void _showButtonPressDialog(BuildContext context, String provider) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$provider Button Pressed!'),
      backgroundColor: Colors.pinkAccent,
      duration: Duration(milliseconds: 400),
    ));
  }

  Padding welcomeMessage() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0),
      child: Text(
        'Chào mừng bạn trở lại',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container signInGoogle() {
    return Container(
      width: 374,
      height: 63,
      child: SignInButton(
        Buttons.Google,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          googleAuth.signIn().then((result){
            result.authentication.then((googleKey){
              FirebaseAuth.instance
                  .signInWithCredential(GoogleAuthProvider.credential(idToken: googleKey.idToken,accessToken: googleKey.accessToken))
              .then((signedInUser){
                print("Login with Google ${signedInUser.user.displayName}");
                //Navigator.of(context).pushReplacementNamed("/Home");
                //userDocumentId = "hEF5nbtt9sEFOyzUSqfG";
                Navigator.push(context, MaterialPageRoute(builder: (_) => ControlTab()));
              }).catchError((e){
                print(e);
              });
            }).catchError((e){
              print(e);
            });
          }).catchError((e){
            print(e);
          });
        },
      ),
    );
  }

  Container signInFacebook() {
    return Container(
      width: 374,
      height: 63,
      child: SignInButton(
        Buttons.Facebook,
        //elevation: 0.0,
        //text: 'ĐĂNG NHẬP BẰNG FACEBOOK',
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          _showButtonPressDialog(context, 'FacebookNew');
        },
      ),
    );
  }

  Padding buildEmailBox() {
    return Padding(
      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        //key: _formKeyEmail,
        //onFieldSubmitted: (value){},
        controller: _emailController,
        validator: (value) {
          if (value == null ||
              value.isEmpty) {
            return 'Please enter email';
          }
          else if (!EmailValidator.validate(value)){
            return 'please enter valid email';
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
    );
  }

  Padding buildPasswordBox() {
    return Padding(
      padding:
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        //decoration: InputDecoration(labelText: 'Password'),
        //key: _formKey,
        controller: _passwordController,
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
            labelText: 'Password',
            hintText: 'Enter secure password'),
      ),
    );
  }

  Container buildLoginButton() {
    return Container(
      height: 63,
      width: 374,
      decoration: BoxDecoration(
          color: Color(0xFF8E97FD), borderRadius: BorderRadius.circular(40)),
      child: FlatButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            //Navigator.push(context, MaterialPageRoute(builder: (_) => ControlTab()));
            _signInWithEmailPassword();
          }
          //_formKeyEmail.currentState.save();
        },
        child: Text(
          'Sign in',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Container buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.deepPurple[400],
          borderRadius: BorderRadius.circular(40)),
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));
        },
        child: Text(
          'New User? Create Account',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                welcomeMessage(),
                Divider(),
                signInGoogle(),
                Divider(),
                signInFacebook(),
                Divider(),
                buildEmailBox(),
                Divider(),
                buildPasswordBox(),
                Divider(),
                buildLoginButton(),
                Divider(),
                buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithEmailPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text))
          .user;
      //if (!user.emailVerified) {
      //  await user.sendEmailVerification();
      //}

      // get user document Id
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      users
          .where("email", isEqualTo: _emailController.text)
          .get()
          .then(
            (QuerySnapshot snapshot) => {
          snapshot.docs.forEach((f) {
            print("documentID---- " + f.reference.id);
            SignIn.userDocumentId = f.reference.id;
          }),
        },
      );

      Navigator.push(context, MaterialPageRoute(builder: (_) => ControlTab()));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Fail to login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 12.0
      );
    }
  }
}