import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/const.dart'; 
import 'package:url_launcher/url_launcher.dart';

// Done by Marlon Mata 
class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key});
  // stores ScrollControllers with labeled names
  final ScrollController _horizontal = ScrollController(); 
  final ScrollController _vertical = ScrollController();
  final ScrollController _hScrollCat = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Playfair Display'), // SU font
      home: Scaffold( // basis of structure
        body: SingleChildScrollView(
          controller: _vertical, // handles vertical scrolling
          child: Center( 
            child: Column(  // starts widgets from top and goes down
              // puts each individual widget on a separate "line" -> Title, boxes, tabs
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [const Text('About This Site', 
                          style: TextStyle(fontWeight: FontWeight.bold, height: 2, fontSize: 30 )),
                // puts things side to side
                Wrap(///////////////////////////////////////////////////// Wrap-to handle small screens
                  spacing: 70,
                  runSpacing: 40,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: [
                    _buildIntro(),
                    _buildCreditBox() 
                  ]
                ),
                Container( // whitespace to separate top boxes from tabs
                  height: 40,
                  width: 10,
                  color: const Color(0xFFFFFFFF),
                ),
                const NestedTabBar(), // handles the how-to section
                Container( // whitespace after tabs
                  height: 40,
                  width: 10,
                  color: const Color(0xFFFFFFFF)
                )
              ]
            )
          ),
        )
      )
    );
  }

  Widget _buildIntro(){
    // change - make boxes proportion change based on size
    return Stack(// box + text overlayed on top of each other
      alignment: Alignment.center,
      children: [
        Container(// for color box
          height: 390,
          width: 390,
          color: const Color(0xFF828282)
        ),
        // help position text, Positioned only works with Stack
        Positioned(// to position text
          child: SizedBox(//////////////////////////////// Container - to enclose text
            height: 370,
            width: 370,
            child: Column(///////////////////////////////// Column - help align text
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(//////////////////////////////////////////// to add hyper link to SU cat partners page
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their ', 
                        style: TextStyle(fontSize: 14, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0))
                      ),
                      TextSpan(
                        text: 'official SU website page',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          color: Colors.blue,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () async{ 
                          Uri url = Uri.parse("https://www.southwestern.edu/life-at-southwestern/student-organizations/special-interest/cat-partners/");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      ),
                      const TextSpan(
                        text: '.', 
                        style: TextStyle(fontSize: 14, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0))
                      )
                    ]
                  )
                ),
                Container( ///////////// used to separate pictures and text
                    height: 40,
                    width: 10,
                    color: const Color(0xFF828282)
                  ),
                SizedBox( ////////////////////////// to have all cat pictures
                  height: 130,
                  width: 340,
                  child: Scrollbar( /////// mini scroll for cat pics
                    controller: _hScrollCat,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: _hScrollCat,
                      children: const [
                        // put images in componenets 
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image(image: AssetImage('images/testCat.PNG'))
                        ),
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image(image: AssetImage('images/testCat.PNG'))
                        ),
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image(image: AssetImage('images/testCat.PNG'))
                        ),
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image(image: AssetImage('images/testCat.PNG'))
                        ),
                        // add text
                      ]
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditBox(){
    return Stack(
      alignment: Alignment.center,
      children: [
        // color box
        Container(
          height: 390,
          width: 390,
          color: const Color(0xFF828282)
        ),
        // help position text, Positioned only works with Stack
        const Positioned(
          child: SizedBox(
            height: 370,
            width: 370,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('    This site was created during the Spring semester of 2024 as part of a Computer Science Capstone project. Along with input from Cat Partners, the following individuals have worked on making this site a reality:', 
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))),
              ],
            ),
          ),
        ),
        Positioned(
          top: 110,
          left: 70,
          child: Column(
            children: [
              const SizedBox(
                height: 90,
                width: 90,
                // if it is images/testPfp.jpg, it is used for testing
                child: Image(image: AssetImage('images/testPfp.jpg'))
              ),
              const Text('Anna Wicker', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))),
              Container(
                height: 30,
                width: 10,
                color: const Color(0xFF828282)
              ),
              const SizedBox(
                height: 90,
                width: 90,
                //color: const Color(0xFF000000)
                // if it is images/testPfp.jpg, it is used for testing
                child: Image(image: AssetImage('images/testPfp.jpg'))
              ),
              const Text('Marlon Mata', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)))
            ]
          )
        ),
        Positioned(
          top: 110,
          right: 70,
          child: Column(
            children: [ ////////////// credits, please don't alter unless changing pictures
              const SizedBox(
                height: 90,
                width: 90,
                // if it is images/testPfp.jpg, it is used for testing
                child: Image(image: AssetImage('images/testPfp.jpg'))
              ),
              const Text('Jayden Beuachua', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))),
              Container(
                height: 30,
                width: 10,
                color: const Color(0xFF828282)
              ),
              const SizedBox(
                height: 90,
                width: 90,
                // if it is images/testPfp.jpg, it is used for testing
                child: Image(image: AssetImage('images/testPfp.jpg'))
              ),
              const Text('Yunhyeong\n"Daniel" Na', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)))
            ]
          )
        )
      ],
    );
  }
}


/*
  The following classes is for implementing the tabs bar for the how-to section
*/
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
    _nestedTabController = TabController(length: 4, vsync: this); // length: 4 = 4 tabs
  }
  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    double containerHeight;

    // adjustable size of tabs section
    {
      if(screenWidth <= 410){ // temp values, will change later
        containerWidth = 390;
        containerHeight = 850;
      } else if(screenWidth > 410 && screenWidth < 870){
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
            labelColor: SUYellow,
            unselectedLabelColor: Colors.black54, // change to grey
            isScrollable: true,
            tabs: const [ ///////////////// the tab options
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Admin'),
              Tab(icon: Icon(Icons.person), text: 'Sign Up To Feed'),
              Tab(icon: Icon(Icons.person), text: 'Account'),
            ],
          ),
          TabBarView( //////////////////////////what is contained in each tab, must match TabBar length
            controller: _nestedTabController,
            children: const [ // containers with alignment
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('The Home page is where users will defualt towards when loging in.', style: TextStyle(fontSize: 18),),
                  Text('Here you can view the current time slots filled in for the next few days.', style: TextStyle(fontSize: 18),),
                  Text('Along with that, any news will also be viewable here as well.', style: TextStyle(fontSize: 18),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('This page is only available to those that have been granted admin permissions. If you have questions regarding gaining access to this page, please ask ________', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                  Text('', style: TextStyle(fontSize: 18),),
                  Text('On this page, Admins can do the following:', style: TextStyle(fontSize: 18),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('This page is only available to those that have been granted admin permissions. If you have questions regarding gaining access to this page, please ask ________', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                  Text(''),
                  Text('On this page, Admins can do the following:', style: TextStyle(fontSize: 18),),
                ],
              ),
              Column(
                children: [
                  Text('The Account page is where information about you is stored', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                  Text('This information can be changed depending on your current status, either by yourself or by the admins(should need be)', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                  Text('Here are the following information categories:', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Name: This should be the name that the school has and/or your preferred name',style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                  //       Text("Email: How the admins can contact you. It doesn't have to be your school email(especially for alumnai and other individuals)", style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                  //       Text('Phone Number: How admins can contact you', style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                  //       Text('Status: What is your affliation with the school and organization. Can change', style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                  //       Text('Notifications: Mark whether or not you want to be notified of time slots or other important things', style: TextStyle(fontSize: 18), textAlign: TextAlign.left)
                  //     ],
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ]
      )
    );
  }
}