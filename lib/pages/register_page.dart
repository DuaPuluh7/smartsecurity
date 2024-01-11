import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/components/mytextfield.dart';
import 'package:flutter/services.dart';
import 'package:iot/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // Kolom Nama
  final phoneController = TextEditingController(); // Kolom No Telepon
  final phoneFormatter = FilteringTextInputFormatter.digitsOnly;


  void createUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showCustomAlertDialog(
        context,
        'Error',
        'Please fill in both email and password fields.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lakukan apa yang perlu dilakukan setelah registrasi berhasil di sini

    } catch (e) {
      showCustomAlertDialog(
        context,
        'Error',
        'Registration failed. Please try again.',
      );
    }
  }

  void toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void showCustomAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Poopins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E55C0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),
                MyTextField(
                  controller: nameController,
                  hintText: 'Nama', // Kolom Nama
                  fontFamily: 'Poopins',
                  icon: Icons.person,
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: phoneController,
                  hintText: 'No Telepon',
                  fontFamily: 'Poopins',
                  icon: Icons.phone,
                  inputFormatter: [phoneFormatter], // Menggunakan InputFormatter
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  fontFamily: 'Poopins',
                  icon: Icons.email,
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password 6 - 12 kata',
                  fontFamily: 'Poopins',
                  icon: Icons.lock,
                  isObscure: _isObscure,
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Confirm Password 6 - 12 kata',
                  fontFamily: 'Poopins',
                  icon: Icons.lock,
                  isObscure: _isObscure,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: Size(double.infinity, 55),
                  ),
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poopins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Poopins',
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF3161FE),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poopins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
