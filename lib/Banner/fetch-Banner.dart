import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../color.dart';
import 'AddBanner.dart';
import 'EditBanner.dart';

class FetchBanner extends StatefulWidget {
  @override
  _FetchBannerState createState() => _FetchBannerState();
}

class _FetchBannerState extends State<FetchBanner> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance
        .collection('Banner')
        .doc(categoryId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateBanner()));
                },
                child: Icon(
                  Icons.add,
                  color: valo,
                )),
          )
        ],
        title: Text('Banner', style: TextStyle(color: CupertinoColors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Search Banner",
                  hintStyle: TextStyle(color: valo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: valo),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Banner').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final List<DocumentSnapshot> categoryDocs = snapshot.data!.docs;
                  final searchQuery = _searchController.text.toLowerCase();

                  final filteredCategories = categoryDocs.where((categoryDoc) {
                    final categoryData = categoryDoc.data() as Map<String, dynamic>;
                    final categoryName = categoryData['Banner name']?.toString().toLowerCase() ?? '';

                    return categoryName.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final categoryData = filteredCategories[index].data() as Map<String, dynamic>;
                      final BannerId = filteredCategories[index].id;

                      return Dismissible(
                        key: Key(BannerId),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text('Are you sure you want to delete this Banner?'),
                                actions: <Widget>[
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
                        onDismissed: (direction) async {
                          await _deleteCategory(BannerId);
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBanner(
                                  bannerId: BannerId,
                                  bannerName: categoryData['Banner name'],
                                  imageUrl: categoryData['image'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 20,
                            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Row(
                                children: [
                                  Spacer(),
                                  Text(categoryData['Banner name'] ?? 'Banner name', style: TextStyle(fontSize: 18)),
                                  Spacer(),
                                  categoryData['image'] != null
                                      ? Image.network(categoryData['image'], width: 130, height: 200)
                                      : Placeholder(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
