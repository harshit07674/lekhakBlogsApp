import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lekhk/screens/auth/mainScreens/bottom_nav_screen.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.endsWith('@gmail.com')) {
      return 'Email must end with @gmail.com';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6 ||
        !RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must be at least 6 characters, contain one uppercase letter and one number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: validateEmail,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: validatePassword,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: validateConfirmPassword,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (_formKey.currentState!.validate()) {
                          /*
                          String profileUrl = '';
                          final profileImage = Supabase.instance.client.storage
                              .from('ProfileImages')
                              .upload(
                                  "blogUserProfiles/${emailController.text}",
                                  _image!,
                                  fileOptions: const FileOptions(
                                    upsert: false,
                                  ))
                              .then((val) {
                            profileUrl = Supabase.instance.client.storage
                                .from('ProfileImages')
                                .getPublicUrl(
                                    "blogUserProfiles/${emailController.text}");
                            Supabase.instance.client.auth
                                .signUp(
                                    password: passwordController.text,
                                    email: emailController.text);
                              
                               Supabase.instance.client
                                  .from("blogUsers")
                                  .insert(
                                {
                                
                                  'email': emailController.text,
                                  'user_name': emailController.text
                                      .split('@')[0]
                                      .toString(),
                                  'articles_written': 0,
                                  'points': 0,
                                  'profile_url': profileUrl,
                                  'followers':[],
                                  'following':[],
                                }
                              ).then((data) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              
                            
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavBarExample()));
                                        

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Successfully uploaded",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ));
                            
                          }).catchError((e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "$e",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ));
                          });
                          */
                          String profileImage = '';
                          String date = DateTime.now().day.toString() +
                              '-' +
                              DateTime.now().month.toString() +
                              '-' +
                              DateTime.now().year.toString();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((sucess) {
                            FirebaseStorage.instance
                                .ref()
                                .child(
                                    'blogUserProfile/${emailController.text}')
                                .putFile(_image!)
                                .then((uploadData) async {
                              profileImage = await FirebaseStorage.instance
                                  .ref()
                                  .child(
                                      'blogUserProfile/${emailController.text}')
                                  .getDownloadURL();

                              FirebaseFirestore.instance
                                  .collection('blogUsers')
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser!.uid}')
                                  .set({
                                'userName': emailController.text.split('@')[0],
                                'email': emailController.text,
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                                'articlesWritten': 0,
                                'followers': [],
                                'following': [],
                                'bio':'',
                                'points': 0.0,
                                'profileUrl': profileImage,
                                'likes': 0,
                                'created': date
                              }).then((data) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Successfully id created",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            BottomNavBarExample()));
                              }).catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "error occurred: $e",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              });
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Sign Up',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Have you already signed up?",
                      style: TextStyle(color: Colors.white54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => BottomNavBarExample()));
                        // Navigate to login screen
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
