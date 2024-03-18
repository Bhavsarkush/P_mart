import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p_mart/Subcategory-Model/SubCategory-Fetch.dart';
import 'package:p_mart/Subcategory-Model/Subcategory.dart';
import '../color.dart';
import 'EditScrn.dart';
import 'ModelSubCategory.dart';
import 'SubCategory-Fetch.dart';
import 'SubCategory-Fetch.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({Key? key}) : super(key: key);

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  late TextEditingController searchController;
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchQuery = '';
  }

  void _deleteSubCategory(String subCategoryID) {
    FirebaseFirestore.instance
        .collection('SubCategories')
        .doc(subCategoryID)
        .delete()
        .then((value) {
      _showToast('SubCategory deleted successfully', Colors.green);
    }).catchError((error) {
      _showToast('Failed to delete SubCategory', Colors.red);
    });
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: const Text(
          'Sub Category',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSubCategory()),
                );
              },
              child: Icon(
                Icons.add,
                color: valo,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: valo),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search SubCategory',
                    hintStyle: TextStyle(color: valo),
                    suffixIcon: Icon(Icons.search, color: valo),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SubCategoryListWidget(
                deleteSubCategory: _deleteSubCategory,
                searchQuery: searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubCategoryListWidget extends StatelessWidget {
  final Function(String) deleteSubCategory;
  final String searchQuery;

  const SubCategoryListWidget({
    Key? key,
    required this.deleteSubCategory,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      FirebaseFirestore.instance.collection('SubCategories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final subCategoryDocs = snapshot.data!.docs;
        List<SubCategoryModel> subCategories = [];

        for (var doc in subCategoryDocs) {
          final subCategory = SubCategoryModel.fromSnapshot(doc);
          subCategories.add(subCategory);
        }

        List<SubCategoryModel> filteredSubCategories = subCategories
            .where((subCategory) => subCategory.subcategory
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredSubCategories.length,
          itemBuilder: (context, index) {
            final subCategory = filteredSubCategories[index];
            return InkWell(
              onTap: () {
                // Handle onTap event here
                // For example, navigate to another screen or perform an action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditSubCategoryScreen(Subcategory: subCategory, image: subCategory.image)),
                );
              },
              child: Dismissible(
                key: Key(subCategory.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete this subcategory?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    deleteSubCategory(subCategory.id);
                  }
                },
                child: Card(
                  color: CupertinoColors.white, // Grey color
                  elevation: 30,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              subCategory.subcategory,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Image.network(subCategory.image,
                                width: 130, height: 200),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
