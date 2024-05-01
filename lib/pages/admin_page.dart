import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/edit_accounts_content.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/edit_admin_content.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/edit_cats_content.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/edit_feeding_stations_content.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/search_accounts_content.dart';
import 'package:flutter_application_1/pages/admin_tabs_content/export_data.dart';

import '../components/user_google.dart';
import '../models/userdoc.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<dynamic>>? _futureFruit; // Define Future for getFruit function

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Playfair Display'),
      home: const Scaffold(
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
                SizedBox(height: 40),
                NestedTabBar(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 6, vsync: this);
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

    /// Checks whether the user can access the admin page.
    /// Only true if the user is logged in and they're set as an admin in the database.
    Future<bool> canUserSeeAdminPage() async {
      // User must be logged in
      if(UserGoogle.auth.currentUser != null){
        UserDoc currentUser = UserDoc.fromJson((await UserGoogle.getUserDoc()).data()!);
        // User must be an admin
        return currentUser.isAdmin;
      } else { 
        return false; 
      }
    }

    return FutureBuilder(
      future: canUserSeeAdminPage(),
      builder: (context, snapshot) {
        // Waiting for verification
        if(!snapshot.hasData) {
          return const Text('Verifying...');
        }
        // User may not access
        if(!snapshot.data!){
          return const Text('You do not have access to this page.');
        }

        return Container(
          height: containerHeight,
          width: containerWidth,
          color: Color.fromARGB(255, 202, 202, 202),
          child: Column(
            children: [
              TabBar(
                tabAlignment: TabAlignment.center,
                controller: _nestedTabController,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                isScrollable: true,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(icon: Icon(Icons.account_box), text: 'Edit Accounts'),
                  Tab(icon: Icon(Icons.admin_panel_settings), text: 'Edit Admin Users'),
                  Tab(icon: Icon(Icons.pets), text: 'Edit Cats'),
                  Tab(icon: Icon(Icons.local_dining), text: 'Edit Feeding Stations'),
                  Tab(icon: Icon(Icons.search), text: 'Search Users'),
                  Tab(icon: Icon(Icons.download), text: 'Export Data'),
                ],
              ),
              SizedBox(
                height: containerHeight - 100,
                width: containerWidth - 80,
                child: TabBarView(
                  controller: _nestedTabController,
                  children: [
                    // Contents for each tab
                    // Edit Accounts tab content
                    const EditAccountsContent(textColor: Colors.black),
                    // Edit Admin tab content
                    const EditAdminContent(textColor: Colors.black),
                    // Edit Cats tab content
                    const EditCatsContent(textColor: Colors.black),
                    // Edit Feeding Stations tab content
                    const EditFeedingStationsContent(textColor: Colors.black),
                    // Search users tab content
                    SearchUsersContent(textColor: Colors.black),
                    // Export Data tab content
                    const ExportDataContent(textColor: Colors.black),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

void main() {
  runApp(AdminScreen());
}
