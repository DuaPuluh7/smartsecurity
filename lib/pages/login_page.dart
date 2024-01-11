import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot/components/mytextfield.dart';
import 'package:iot/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserin() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Lakukan apa yang perlu dilakukan setelah login berhasil di sini
    } catch (e) {
      showCustomAlertDialog(
        context,
        'Error',
        'Login failed. Please check your email and password.',
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
                  'SMART HOME SECURITY SYSTEM',
                  style: TextStyle(
                    fontFamily: 'Poopins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E55C0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 70),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  fontFamily: 'Poppins',
                  icon: Icons.email,
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  fontFamily: 'Poppins',
                  icon: Icons.lock,
                  isObscure: _isObscure,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      signUserin();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have any account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                        onTap: () {
                          // Navigate to RegisterPage when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFF3161FE),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Image.asset(
                  'lib/img/vector.png',
                  height: 200,
                  width: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
