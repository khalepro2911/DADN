import 'dart:io';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool showPassword = false;
  final nameRegExp = RegExp('[a-zA-Z]');
  final phoneRegExp = RegExp(r"^\+?0[0-9]{9}$");
  int image = 0;
  File _imageFile;
  String _imagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }
  void getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      _imageFile = File(pickedFile.path);
      saveImage();
      loadImage();
    });
  }
  void saveImage() async {
    SharedPreferences saveImageVar1 = await SharedPreferences.getInstance();
    saveImageVar1.setString("imagepath", _imageFile.path);
  }
  void loadImage() async{
    SharedPreferences saveImageVar2 = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = saveImageVar2.getString("imagepath");
    });
  }

  updateUserInformation(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update your information"),
      content: Text("Do you want to change your information?"),
      actions: <Widget>[
        FlatButton(
          child: const Text('Save'),
          onPressed: () {
            updateUser();
            Navigator.of(context).pop();
            loadImage();
          },
        ),
        FlatButton(
          child: const Text('Cancel'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 10, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Row(
                children: [
                  SizedBox(width: 40,),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.deepPurpleAccent,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 63.0,
                              child: _imagePath != null
                                  ? CircleAvatar(backgroundImage: FileImage(File(_imagePath)), radius: 56,)
                                  : CircleAvatar(backgroundImage: _imageFile != null ? FileImage(_imageFile): NetworkImage('http://tgo.vn/wp-content/uploads/2021/01/white-background-2-1536x900.jpg'), radius: 56),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 75,
                          child: FlatButton(
                            shape: CircleBorder(side: BorderSide(color: Colors.deepPurpleAccent)),
                            onPressed: (){
                              getFromGallery();
                              image = 1;
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                ),
                                color: Colors.deepPurpleAccent,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn()));
                    },
                    color: Colors.deepPurpleAccent,
                    child: Text("Log out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              GetUserInformation(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 110,vertical: 5),
                height: 50,
                child: ButtonTheme(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurpleAccent,
                    child: FlatButton(
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      onPressed: (){
                        if (GetUserInformation.formKey.currentState.validate()) {
                          updateUserInformation(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
CollectionReference users = FirebaseFirestore.instance.collection('user');
Future<void> updateUser(){
  return users
      .doc(SignIn.userDocumentId)
      .update({'name': GetUserInformation.updateFullName.text, 'phone': GetUserInformation.updatePhoneNumber.text, 'email': GetUserInformation.updateEmail.text})
      .then((_) {
  }).catchError((error) => print("Failed to update user: $error"));
}

class GetUserInformation extends StatelessWidget {
  final nameRegExp = RegExp('[a-zA-Z]');
  final phoneRegExp = RegExp(r"^\+?0[0-9]{9}$");
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController updateFullName = TextEditingController();
  static TextEditingController updatePhoneNumber = TextEditingController();
  static TextEditingController updateEmail = TextEditingController();

  TextFormField buildTextField(TextEditingController controller, String labelText){
    String validation(){
      if (controller.text.isEmpty) return "Enter your $labelText";
      else {
        if (
            (controller == updateFullName && !nameRegExp.hasMatch(controller.text))
            || (controller == updatePhoneNumber && !phoneRegExp.hasMatch(controller.text))
            || (controller == updateEmail && !EmailValidator.validate(controller.text))
        )
        return "Enter a valid $labelText";
        else return null;
      }
    }
    return TextFormField(
      //obscureText: isPasswordTextField ? showPassword : false,
      controller: controller,
      validator: (value) =>validation(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 3),
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          //color: Colors.blue,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: controller.text,
        hintStyle: TextStyle(
          color: Colors.black38,
          decoration: TextDecoration.none,
        ),
        fillColor: Colors.red,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    //print("tessssssssssssssssssst----$documentId");
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(SignIn.userDocumentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data.data();
          //print("test: $data");
          updateFullName.text = data['name'];
          updatePhoneNumber.text = data['phone'];
          updateEmail.text = data['email'];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildTextField(updateFullName, "Full name"),
                  SizedBox(height: 20,),
                  buildTextField(updatePhoneNumber, "Phone number"),
                  SizedBox(height: 20,),
                  buildTextField(updateEmail, "Email"),
                ],
              ),
            ),
          );
        }
        return Text("Loading");
      },
    );
  }
}

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'ControlTab.dart';
import 'SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  //bool showPassword = false;
  //final nameRegExp = RegExp('[a-zA-Z]');
  //final phoneRegExp = RegExp(r"^\+?0[0-9]{9}$");
  File _imageFile;
  String _imagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
    loadImage();
  }
  void getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      _imageFile = File(pickedFile.path);
      saveImage();
      loadImage();
    });
  }
  void saveImage() async {
    SharedPreferences saveImageVar1 = await SharedPreferences.getInstance();
    saveImageVar1.setString("imagepath", _imageFile.path);
  }
  void loadImage() async{
    SharedPreferences saveImageVar2 = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = saveImageVar2.getString("imagepath");
    });
  }
  updateUserInformation(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update your information"),
      content: Text("Do you want to change your information?"),
      actions: <Widget>[
        FlatButton(
          child: const Text('Save'),
          onPressed: () {
            //updateUser();
            users
                .doc(SignIn.userDocumentId)
                .update({'name': GetUserInformation.updateFullName.text, 'phone': GetUserInformation.updatePhoneNumber.text, 'email': GetUserInformation.updateEmail.text})
                .then((_) {
            }).catchError((error) => print("Failed to update user: $error"));
            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
            //loadImage();
          },
        ),
        FlatButton(
          child: const Text('Cancel'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 10, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Row(
                children: [
                  SizedBox(width: 40,),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.deepPurpleAccent,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 63.0,
                              child: _imagePath != null
                                  ? CircleAvatar(backgroundImage: FileImage(File(_imagePath)), radius: 56,)
                                  : CircleAvatar(backgroundImage: _imageFile != null ? FileImage(_imageFile): NetworkImage('http://tgo.vn/wp-content/uploads/2021/01/white-background-2-1536x900.jpg'), radius: 56),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 75,
                          child: FlatButton(
                            shape: CircleBorder(side: BorderSide(color: Colors.deepPurpleAccent)),
                            onPressed: (){
                              getFromGallery();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                ),
                                color: Colors.deepPurpleAccent,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn()));
                      //getUser();
                    },
                    color: Colors.deepPurpleAccent,
                    child: Text("Log out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              //SizedBox(height: 20,),
              GetUserInformation(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 110,vertical: 5),
                height: 50,
                child: ButtonTheme(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurpleAccent,
                    child: FlatButton(
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      onPressed: (){
                        if (GetUserInformation.formKey.currentState.validate()) {
                          updateUserInformation(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
CollectionReference users = FirebaseFirestore.instance.collection('user');
/*
Future<void> updateUser(){
  return users
      .doc(SignIn.userDocumentId)
      .update({'name': GetUserInformation.updateFullName.text, 'phone': GetUserInformation.updatePhoneNumber.text, 'email': GetUserInformation.updateEmail.text})
      .then((_) {
  }).catchError((error) => print("Failed to update user: $error"));
}
*/
class GetUserInformation extends StatelessWidget {
  final nameRegExp = RegExp('[a-zA-Z]');
  final phoneRegExp = RegExp(r"^\+?0[0-9]{9}$");
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static TextEditingController updateFullName = TextEditingController();
  static TextEditingController updatePhoneNumber = TextEditingController();
  static TextEditingController updateEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //print("tessssssssssssssssssst----$documentId");
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(SignIn.userDocumentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data.data();
          //print("test: $data");
          updateFullName.text = data['name'];
          updatePhoneNumber.text = data['phone'];
          updateEmail.text = data['email'];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                    TextFormField(
                    //obscureText: isPasswordTextField ? showPassword : false,
                    controller: updateFullName,
                    validator:(value){
                      value = updateFullName.text;
                      if(value.isEmpty) return "Enter your name";
                      else if(!nameRegExp.hasMatch(value)) return "Enter a valid name";
                      else return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Full name",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: updateFullName.text,
                      //hintTextDirection: TextDirection.rtl,
                      //prefixIcon: Icon(Icons.person),

                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    //obscureText: isPasswordTextField ? showPassword : false,
                    controller: updatePhoneNumber,
                    validator:(value){
                      value = updatePhoneNumber.text;
                      if(value.isEmpty) return "Enter your phone number";
                      else if(!phoneRegExp.hasMatch(value)) return "Enter a valid phone number";
                      else return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Phone number",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: updatePhoneNumber.text,
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    //obscureText: isPasswordTextField ? showPassword : false,
                    controller: updateEmail,
                    validator:(value){
                      value = updateEmail.text;
                      if(value.isEmpty) return "Enter your email";
                      else if(!EmailValidator.validate(value)) return "Enter a valid email";
                      else return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: updateEmail.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Text("Loading");
      },
    );
  }
}
*/


