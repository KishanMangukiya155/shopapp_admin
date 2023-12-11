import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shopapp_admin/firbase_service.dart';
import 'package:shopapp_admin/screen/category_list_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _catName = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  dynamic image;
  String? fileName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      print("Failed");
    }
  }

  saveImageToDb() async {
    EasyLoading.show();
    var ref = firebase_storage.FirebaseStorage.instance
        .ref("categoryImage/$fileName");

    try {
      await ref.putData(image);
      String downloadURL = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(
            data: {
              'catName': _catName.text,
              "image": value,
              "active": true,
            },
            docName: _catName.text,
            reference: _service.categories,
          ).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      clear();
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  clear() {
    setState(() {
      _catName.clear();
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text(
              'Category Screen',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Container(
                        child: image == null
                            ? Center(child: Text("Category Image"))
                            : Image.memory(
                                image,
                                fit: BoxFit.cover,
                              )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text("Upload Image"),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 200,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Category Name";
                    }
                  },
                  controller: _catName,
                  decoration: InputDecoration(
                    label: Text("Enter Category Name"),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
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
              image == null
                  ? Container()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          saveImageToDb();
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
            ],
          ),
          Divider(color: Colors.grey),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: Text("Category List",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          ),
          SizedBox(
            height: 10,
          ),
          CategoryListWidget(),
        ],
      ),
    );
  }
}
