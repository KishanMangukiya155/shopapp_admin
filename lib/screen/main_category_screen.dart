import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopapp_admin/firbase_service.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'main category';
  const MainCategoryScreen({super.key});

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _mainCat = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;

  Widget _dropDownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: Text("Select Category"),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
            value: e['catName'], child: Text(e['catName']));
      }).toList(),
      onChanged: (selectedCat) {
        setState(() {
          _selectedValue = selectedCat;
          _noCategorySelected = false;
        });
      },
    );
  }

  clear() {
    setState(() {
      _selectedValue = null;
      _mainCat.clear();
    });
  }

  @override
  void initState() {
    getCatList();
    super.initState();
  }

  getCatList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                'Main Category Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            snapshot == null ? Text("Loading") : _dropDownButton(),
            SizedBox(
              height: 8,
            ),
            if (_noCategorySelected == true)
              Text("No Category Selected", style: TextStyle(color: Colors.red)),
            SizedBox(
              width: 200,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Main Category Name";
                  }
                },
                controller: _mainCat,
                decoration: InputDecoration(
                  label: Text("Enter Category Name"),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(children: [
              TextButton(
                onPressed: clear,
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.blue))),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedValue == null) {
                    setState(() {
                      _noCategorySelected = true;
                    });
                    return;
                  }
                  if (_formkey.currentState!.validate()) {
                    EasyLoading.show();
                    _service.saveCategory(
                        data: {
                          "category": _selectedValue,
                          "mainCategory": _mainCat.text,
                          "approved": true,
                        },
                        reference: _service.mainCat,
                        docName: _mainCat.text).then((value) {
                      clear();
                      EasyLoading.dismiss();
                    });
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.blue))),
              ),
            ]),
            Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
