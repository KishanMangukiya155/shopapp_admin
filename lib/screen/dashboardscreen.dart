import 'package:flutter/cupertino.dart';

class DashBoardScreen extends StatelessWidget {
  static const String id = 'dashboard';
  const DashBoardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),
      ),
    );
  }
}
