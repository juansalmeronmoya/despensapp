import 'package:despensapp/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';

class Product {
  final String name;

  late final String description;

  Product({required this.name, required this.description});

  Product.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            description: (json['description'] != null)
                ? json['description']! as String
                : 'withoutdescription');

  Map<String, Object?> toJson() {
    return {'name': name, 'description': description};
  }
}

final productsCollection =
    FirebaseFirestore.instance.collection('products').withConverter(
          fromFirestore: ((snapshot, options) =>
              Product.fromJson(snapshot.data()!)),
          toFirestore: (product, _) => product.toJson(),
        );

/// Displays a list of SampleItems.
class ProductListView extends StatelessWidget {
  static const routeName = '/products';

  const ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: FirestoreListView<Product>(
          query: productsCollection.orderBy('name'),
          pageSize: 50,
          itemBuilder: (context, snapshot) {
            Product product = snapshot.data();
            return Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.album),
                      title: Text(product.name),
                      subtitle: (product.description.isNotEmpty)
                          ? Text(product.description)
                          : Text('sindescripcion'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
