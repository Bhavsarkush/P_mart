// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
// import 'package:peakmart/PeakMart.dart';
// import 'package:peakmart/admin.dart';
import '../Admin.dart';
import 'Signup.dart';
import '../color.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          child: Column(
            children: [
              SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: Image.asset("assets/images/login.jpg")),
              SizedBox(
                height: 10,
              ),

              // Image.asset("assets/images/Userlogin.png", width: 50, height: 50),
              Icon(
                Icons.supervised_user_circle_outlined,
                color: valo,
                size: 60,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Login ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25, color: valo),
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Colors.lightGreenAccent, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              // SizedBox(height: 15,),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(valo),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Admin()));
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account?"),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Shop()));
                    },
                    child: const Text("Sign up",
                        style: TextStyle(color: valo, fontSize: 15)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
