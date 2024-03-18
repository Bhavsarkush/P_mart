import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p_mart/Category/Addcategory.dart';
import '../color.dart';
import 'CategoryModel.dart';
import 'EditCategory.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late TextEditingController searchController;
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchQuery = '';
  }

  void _deleteCategory(String categoryID) {
    FirebaseFirestore.instance
        .collection('Categories')
        .doc(categoryID)
        .delete()
        .then((value) {
      _showToast('Category deleted successfully', Colors.green);
    }).catchError((error) {
      _showToast('Failed to delete category', Colors.red);
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
        title: Text(
          'Category',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => add()),
                );
              },
              child: Icon(Icons.add, color: valo),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
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
                    hintText: 'Search Category',
                    hintStyle: TextStyle(color: valo),
                    suffixIcon: Icon(Icons.search, color: valo),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: CategoryListWidget(
                deleteCategory: _deleteCategory,
                searchQuery: searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {
  final Function(String) deleteCategory;
  final String searchQuery;

  const CategoryListWidget({
    Key? key,
    required this.deleteCategory,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final categoryDocs = snapshot.data!.docs;
        List<CategoryModel> categories = [];

        for (var doc in categoryDocs) {
          final category = CategoryModel.fromSnapshot(doc);
          categories.add(category);
        }

        // Filter categories based on the search query
        List<CategoryModel> filteredCategories = categories
            .where((category) => category.category.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return CategoryCard(
              category: category,
              onDelete: () => _showDeleteDialog(context, category.id),
              onEdit: () => _navigateToEditScreen(context, category),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(categoryId);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(BuildContext context, CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category, image: category.image),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(category.id),
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
              content: Text('Are you sure you want to delete this category?'),
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
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onEdit,
        child: Card(
          elevation: 30,
          color:CupertinoColors.white ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 10),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(category.category, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                Spacer(),
                Image.network(category.image, width: 130, height: 200),
                  ],
                ),

            ),
          ),
        ),

    );
  }
}

