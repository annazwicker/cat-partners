import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Playfair Display'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const Text(
                //   'About This Site',
                //   style: TextStyle(fontWeight: FontWeight.bold, height: 2, fontSize: 30),
                // ),
                const SizedBox(height: 40),
                const NestedTabBar(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({Key? key}) : super(key: key);

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    double containerHeight;

    {
      if (screenWidth <= 410) {
        containerWidth = 390;
        containerHeight = 850;
      } else if (screenWidth > 410 && screenWidth < 870) {
        containerWidth = screenWidth - 20;
        containerHeight = -screenWidth + 1370;
      } else {
        containerWidth = 850;
        containerHeight = 500;
      }
    }

    return Container(
      height: containerHeight,
      width: containerWidth,
      color: const Color(0xFF828282),
      child: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.center,
            controller: _nestedTabController,
            indicatorColor: Colors.black,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.black54,
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.edit), text: 'Edit Accounts'),
              Tab(icon: Icon(Icons.person), text: 'Edit Admin Users'),
              Tab(icon: Icon(Icons.pets), text: 'Edit Cats'),
              Tab(icon: Icon(Icons.local_dining), text: 'Edit Feeding Stations'),
              Tab(icon: Icon(Icons.download), text: 'Export Data'),
            ],
          ),
          SizedBox(
            height: containerHeight - 100,
            width: containerWidth - 80,
            child: TabBarView(
              controller: _nestedTabController,
              children: const [
                // Contents for each tab
                Text('Edit Accounts Content'),
                Text('Edit Admin Users Content'),
                Text('Edit Cats Content'),
                Text('Edit Feeding Stations Content'),
                Text('Export Data Content'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(AdminScreen());
}
