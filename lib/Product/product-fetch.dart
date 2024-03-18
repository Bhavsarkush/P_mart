import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Addporduct.dart';
import 'EditProduct.dart';
import 'Model.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _searchText = '';



  void _deleteProduct(String productID) {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(productID)
        .delete()
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Product Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete category',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyan),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Product...',
                      hintStyle: TextStyle(color: Colors.cyan),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ProductList(deleteProduct: _deleteProduct, searchText: _searchText),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const addProductsScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 25.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProductList extends StatelessWidget {
  final Function(String) deleteProduct;
  final String searchText;

  const ProductList({
    Key? key,
    required this.deleteProduct,
    required this.searchText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final productDocs = snapshot.data!.docs;
          List<ProductModel> products = [];

          for (var doc in productDocs) {
            final product = ProductModel.fromSnapshot(doc);
            products.add(product);
          }

          List<ProductModel> filteredProducts = products
              .where((product) =>
              product.productName.toLowerCase().contains(searchText))
              .toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              String imageUrl =
              product.images!.isNotEmpty ? product.images![0] : '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Center(
                        child: Image.network(imageUrl, width: 200, height: 200),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProduct(
                                          product: product,
                                          images: product.images != null &&
                                              product.images!.isNotEmpty
                                              ? product.images![0]
                                              : '',
                                        )),
                                  );
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.cyan),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Confirm Deletion',
                                        ),
                                        content: const Text(
                                            'Are you sure you want to delete this category?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteProduct(product.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Delete',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
