import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter_application_1/const.dart'; 
import 'package:url_launcher/url_launcher.dart';

// Done by Marlon Mata 
class AboutScreen extends StatelessWidget {
  AboutScreen({super.key, Key? keyInstance});
  // stores ScrollControllers with labeled names
  final ScrollController _vertical = ScrollController();
  final ScrollController _ScrollCat = ScrollController();

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
                _buildIntro(context), ///////////////////////////////////////////// builds intro box
                Container( // whitespace to separate intro box from tabs
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

  Widget _buildIntro(BuildContext context){
    // checks the size of the window
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    double containerHeight;

    // adjustable size intro box
    {
      if(screenWidth <= 410){
        containerWidth = 370;
        containerHeight = 950;
      } else if(screenWidth > 410 && screenWidth < 810){
        containerWidth = (1.075*screenWidth) - 70.75;
        containerHeight = (-1.2*screenWidth) + 1362;
      } else {
        containerWidth = 800;
        containerHeight = 390;
      }
    }
    return Stack(// box + text overlayed on top of each other
      alignment: Alignment.center,
      children: [
        Container(// for color box
          height: containerHeight,
          width: containerWidth,
          color: const Color(0xFF828282)
        ),
        // help position text, Positioned only works within Stack
        Positioned(// to position text
          child: SizedBox(//////////////////////////////// Container - to enclose text
            height: containerHeight-20,
            width: containerWidth-20,
            child: Column(///////////////////////////////// Column - help align text
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(//////////////////////////////////////////// to add hyper link to SU cat partners page
                  text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their ', 
                      style: TextStyle(fontSize: 16, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0))
                    ),
                    TextSpan( // location of link
                      text: 'official SU website page',
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16
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
                      style: TextStyle(fontSize: 16, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0))
                    )
                  ]
                )
              ),
              const Text('    This site was created during the Spring semester of 2024 as part of a Computer Science Capstone project. Along with input from Cat Partners, Anna Wicker, Jayfen Beauchua, Yunhyeong "Daniel" Na, and Marlon Mata were able to make this site possible', 
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
              Container( ///////////// used to separate pictures and text
                  height: 10,
                  width: 10,
                  color: const Color(0xFF828282)
                ),
                Builder( /////// builder - to add an if-else statement depending on window size
                  builder: (context){ /// context -> window stuff
                    if(screenWidth < 620){
                      return _verticalCatPics(containerHeight);
                    } else {
                      return _horizontalCatPics(containerWidth);
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _horizontalCatPics(double currentWidth){
    return SizedBox( ////////////////////////// to have all cat pictures
        height: 150,
        width: currentWidth-150,
      child: Scrollbar( /////// mini scroll for cat pics
          controller: _ScrollCat,
          thumbVisibility: true,
          trackVisibility: true,
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: _ScrollCat,
            children: const [
              // put images in componenets 
              // perhaps change it so images uploaded can be brought into here
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/testCat.PNG'))
              ),
              // add text
            ]
          )
        )
    );
  }

  Widget _verticalCatPics(double currentHeight){
    return SizedBox( ////////////////////////// to have all cat pictures
        height: currentHeight-370,
        width: 310,
      child: Scrollbar( /////// mini scroll for cat pics
          controller: _ScrollCat,
          thumbVisibility: true,
          trackVisibility: true,
          child: ListView(
            scrollDirection: Axis.vertical,
            controller: _ScrollCat,
            children: const [
              // put images in componenets 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(image: AssetImage('images/testCat.PNG'))
                  ),
                ]
              ),
              // add text
            ]
          )
        )
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
    // gets window size
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    double containerHeight;

    // adjustable size of tabs section
    {
      if(screenWidth <= 410){
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

    return Container( // contains the tabs, wont take entire screen
      height: containerHeight,
      width: containerWidth,
      color: const Color(0xFF828282),
      child: Column(
        children: [
          TabBar( // tabs; must match length of TabController(length: 4, vsync: this)
            tabAlignment: TabAlignment.center,
            controller: _nestedTabController, // controller that controls tabs
            indicatorColor: Colors.black,
            labelColor: SUYellow,
            unselectedLabelColor: Colors.black54, // change to grey
            isScrollable: true,
            tabs: const [ ///////////////// the tab options, length must match
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Admin'),
              Tab(icon: Icon(Icons.person), text: 'Sign Up To Feed'),
              Tab(icon: Icon(Icons.person), text: 'Account'),
            ],
          ),
          SizedBox( // contents of tabs
            height: containerHeight-100,
            width: containerWidth-80,
            child: TabBarView( //////////////////////////what is contained in each tab, must match TabBar length
              controller: _nestedTabController, // same controller
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('The Home page is where users will defualt towards when loging in.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    ),
                    Text('Here you can view the current time slots filled in for the next few days.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text('Along with that, any news will also be viewable here as well.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                  ],
                ),
                Column( ///// Add padding
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('This page is only available to those that have been granted admin permissions. If you have questions regarding gaining access to this page, please ask ________', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
                    Text('', style: TextStyle(fontSize: 18),),
                    Text('On this page, Admins can do the following:', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('This page is only available to those that have been granted admin permissions. If you have questions regarding gaining access to this page, please ask ________', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
                    Text(''),
                    Text('On this page, Admins can do the following:', style: TextStyle(fontSize: 18),),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('The Account page is where information about you is stored', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
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
          )
        ]
      )
    );
  }
}