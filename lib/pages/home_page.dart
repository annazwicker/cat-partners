import "package:flutter/material.dart";
import "package:flutter_application_1/components/nav_bar.dart";
import 'package:flutter_application_1/const.dart';
import "package:flutter_application_1/services/firebase_helper.dart";



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _dbHelper = FirebaseHelper();
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopNavBar(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  bool _isWindowOpen = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // alignment: AlignmentDirectional.center,
        children: [
          if (_isWindowOpen)
            IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.all(20),
                color: SUYellow,
                width: MediaQuery.of(context).size.width * 0.75,
                // height: MediaQuery.of(context).size.height * 0.08,
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.08),
                child: Column(children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isWindowOpen = false;
                          });
                        },
                        icon: const Icon(Icons.close)),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 45, left: 20, right: 20),
                          child: const Text(
                              'The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and black striped pattern. This is usually caused by the contents being too big for the RenderFlex.')),
                    ),
                  )
                ]),
              ),
            ),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.1,
                  color: SUYellow,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  child: const Text('Achievement Box'))),
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.3,
              color: SUYellow,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: const Text('Scheduler')),
        ],
      ),
    );
  }
}
