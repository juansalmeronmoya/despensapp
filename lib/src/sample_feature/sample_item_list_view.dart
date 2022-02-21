import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';

class Product {
  final String name;

  Product({
    required this.name,
  });

  Product.fromJson(Map<String, Object?> json)
      : this(name: json['name']! as String);

  Map<String, Object?> toJson() {
    return {'name': name};
  }
}

final productsCollection =
FirebaseFirestore.instance.collection('products').withConverter(
  fromFirestore: ((snapshot, options) =>
      Product.fromJson(snapshot.data()!)),
  toFirestore: (Product, _) => Product.toJson(),
);



/// Displays a list of SampleItems.
class ProductListView extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Productos de firestore!')),
    body: FirestoreListView<Product>(
      query: productsCollection.orderBy('name'),
      itemBuilder: (context, snapshot) {
        Product product = snapshot.data();
        return Text(product.name);
      },
    ),
  );
}
