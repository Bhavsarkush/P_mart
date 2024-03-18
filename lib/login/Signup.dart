import 'package:flutter/material.dart';
import 'Login.dart';
import '../color.dart';

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Create Your Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter your phone number",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: valo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: valo),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(valo),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const login()));
                  },
                  child: const Text(
                    "Sign up",
                  ),
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Already have an Account?",
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(valo),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => login()));
                    },
                    child: Text(
                      "Login",
                    ))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
