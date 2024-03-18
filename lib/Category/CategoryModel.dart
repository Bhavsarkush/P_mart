// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String image;
  final String category;

  CategoryModel(
      {required this.id, required this.category, required this.image});

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryModel(
      id: snapshot.id, // Assign the document ID to the id field
      category: snapshot['category'],
      image: snapshot['image'],
    );
  }
}
