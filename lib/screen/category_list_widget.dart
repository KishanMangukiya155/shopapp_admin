import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopapp_admin/firbase_service.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _serivce = FirebaseService();

    Widget categoryWidget(data) {
      return Card(
        color: Colors.grey.shade400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(data['image'], fit: BoxFit.cover)),
              Text(data["catName"]),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _serivce.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.data!.size == 0) {
          return const Text("No Category Added ");
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];
            return categoryWidget(data);
          },
        );
      },
    );
  }
}
