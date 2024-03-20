// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_mart/Category/FetchCategory.dart';
import 'package:p_mart/Product/Addporduct.dart';
import 'package:p_mart/Subcategory-Model/SubCategory-Fetch.dart';
import 'package:p_mart/login/Login.dart';
import 'Banner/fetch-Banner.dart';
import 'Product/product-fetch.dart';
import 'demo.dart';
import 'login/Signup.dart';
import 'color.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        centerTitle: true,
        title: Text(
          "PeakMart",
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: valo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/admin.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Admin Profile",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Orders"),
              onTap: _openOrdersScreen,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text("Notifications"),
              onTap: () {},
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.nightlight),
              title: const Text("Theme"),
              onTap: () {},
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "PeakMart Admin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.0,
                children: List.generate(6, (index) {
                  List<Map<String, dynamic>> cardData = [
                    {
                      "image": "assets/images/category.png",
                      "text": "Category",
                      "onTap": _openCategoryScreen,
                    },
                    {
                      "image": "assets/images/subcategory.png",
                      "text": "SubCategory",
                      "onTap": _openSubCategoryScreen,
                    },
                    {
                      "image": "assets/images/received.png",
                      "text": "Products",
                      "onTap": _openProductsScreen,
                    },
                    {
                      "image": "assets/images/banner.png",
                      "text": "Banners",
                      "onTap": _openBannerScreen,
                    },
                    {
                      "image": "assets/images/delivery-man.png",
                      "text": "UsersOrders",
                      "onTap": _openOrdersScreen,
                    },
                    {
                      "image": "assets/images/all user.png",
                      "text": "All Users",
                      "onTap": _openAllUsersScreen,
                    },
                  ];
                  return GestureDetector(
                    onTap: cardData[index]['onTap'],
                    child: Card(
                      color: Colors.white70,
                      shadowColor: Colors.black87,
                      elevation: 40,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            cardData[index]['image'],
                            height: 30,
                            width: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            cardData[index]['text'],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openCategoryScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryScreen()));
  }

  void _openSubCategoryScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubCategory()));
  }

  void _openProductsScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductScreen()));
  }

  void _openAllUsersScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EShop()));
  }

  void _openBannerScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FetchBanner()));
  }

  void _openOrdersScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EShop()));
  }
}
