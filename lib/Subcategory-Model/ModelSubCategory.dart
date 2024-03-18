import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String id;
  final String image;
  final String category;
  final String subcategory; // Changed parameter name to match constructor

  SubCategoryModel({required this.id,
    required this.category,
    required this.image,
    required this.subcategory}); // Updated parameter name

  factory SubCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubCategoryModel(
      id: snapshot.id, // Assign the document ID to the id field
      category: snapshot['category'],
      image: snapshot['image'],
      subcategory: snapshot['subCategory'],
    );
  }

}