import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shopapp_admin/screen/CategoryScreen.dart';
import 'package:shopapp_admin/screen/dashboardscreen.dart';
import 'package:shopapp_admin/screen/main_category_screen.dart';
import 'package:shopapp_admin/screen/sub_category_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA41nM-HSsmRyczxCkRI5Ggm4yWAToVwkc",
        appId: "1:872443188662:web:973e391e08ccfe8b32dd17",
        messagingSenderId: "872443188662",
        projectId: "ecommerce-app-2470d",
        storageBucket: "ecommerce-app-2470d.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SideMenu(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SideMenu extends StatefulWidget {
  static const String id = 'sidemenu';
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashBoardScreen();

  screenSelected(item) {
    switch (item.route) {
      case DashBoardScreen.id:
        setState(() {
          _selectedScreen = DashBoardScreen();
        });
        break;
      case SubCategoryScreen.id:
        setState(() {
          _selectedScreen = SubCategoryScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;
      case MainCategoryScreen.id:
        setState(() {
          _selectedScreen = MainCategoryScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shop App Admin', style: TextStyle(letterSpacing: 1)),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: IconlyLight.category,
            children: [
              AdminMenuItem(
                title: 'Category',
                route: CategoryScreen.id,
              ),
              AdminMenuItem(
                title: 'Main Category',
                route: MainCategoryScreen.id,
              ),
              AdminMenuItem(
                title: 'Sub Category',
                route: SubCategoryScreen.id,
              ),
            ],
          ),
        ],
        selectedRoute: SideMenu.id,
        onSelected: (item) {
          screenSelected(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: Center(
            child: Text(
              '${DateTimeFormat.format(DateTime.now(), format: AmericanDateFormats.dayOfWeek)}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}
