import 'package:flutter/cupertino.dart';

class SubCategoryScreen extends StatelessWidget {
  static const String id = 'sub category';
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sub Category Screen',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36,
      ),
    );
  }
}
