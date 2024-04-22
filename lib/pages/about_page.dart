import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/const.dart'; 
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

//comment
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
        home: Scaffold(
            // basis of structure
            body: SingleChildScrollView(
          controller: _vertical, // handles vertical scrolling
          child: Center(
              child: Column(
                  // starts widgets from top and goes down
                  // puts each individual widget on a separate "line" -> Title, boxes, tabs
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                const Text('About This Site',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, height: 2, fontSize: 30)),
                _buildIntro(
                    context), ///////////////////////////////////////////// builds intro box
                Container(
                  // whitespace to separate intro box from tabs
                  height: 40,
                  width: 10,
                  color: const Color(0xFFFFFFFF),
                ),
                const NestedTabBar(), // handles the how-to section
                Container(
                    // whitespace after tabs
                    height: 40,
                    width: 10,
                    color: const Color(0xFFFFFFFF))
              ])),
        )));
  }

  Widget _buildIntro(BuildContext context) {
    // checks the size of the window
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    double containerHeight;

    // adjustable size intro box
    {
      if (screenWidth < 850) {
        double slope = (360 - 900)/(850 - 500);
        double y = 900 - (500 * slope);
        containerWidth = screenWidth - 50;
        containerHeight = (slope * screenWidth) + y;
      } else {
        containerWidth = 800;
        containerHeight = 360;
      }
    }
    return Stack(
      // box + text overlayed on top of each other
      alignment: Alignment.center,
      children: [
        Container(
            // for color box
            height: containerHeight,
            width: containerWidth,
            color: const Color.fromARGB(255, 202, 202, 202)),
        // help position text, Positioned only works within Stack
        Positioned(// to position text
          child: SizedBox(//////////////////////////////// Container - to enclose everything
            height: containerHeight-10,
            width: containerWidth-20,
            child: Column(///////////////////////////////// Column - help align text
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: RichText(
                      //////////////////////////////////////////// to add hyper link to SU cat partners page
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              '    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their ',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Playfair Display',
                              color: Color.fromARGB(255, 0, 0, 0))),
                        TextSpan(
                          // location of link
                          text: 'official SU website page',
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            color: Color.fromARGB(255, 19, 147, 252),
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
                          text: '.\n', 
                          style: TextStyle(fontSize: 16, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0))
                        ),
                        const TextSpan(
                          text: '    This site was created during the Spring semester of 2024 as part of a Computer Science Capstone project. Along with input from Cat Partners, Anna Wicker, Jayden Beauchea, Yunhyeong "Daniel" Na, and Marlon Mata were able to make this site possible.',
                          style: TextStyle(fontSize: 16, fontFamily: 'Playfair Display', color: Color.fromARGB(255, 0, 0, 0)),
                        )
                      ]
                    )
                  ),
                ),
              Container( ///////////// used to separate pictures and text
                  height: 10,
                  width: 10,
                  color: const Color.fromARGB(255, 202, 202, 202),
                ),
                Builder( /////// builder - to add an if-else statement depending on window size
                  builder: (context){ /// context -> window stuff
                    if(screenWidth < 700){
                      return _verticalCatPics(containerHeight);
                    } else {
                      return _horizontalCatPics(containerWidth);
                    }
                  }
                ),
                const SizedBox(
                  width: 5,
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _horizontalCatPics(double currentWidth) {
    return SizedBox(
      ////////////////////////// to have all cat pictures
      height: 150,
      width: currentWidth - 150,
      child: Scrollbar(
        /////// mini scroll for cat pics
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
                child: Image(image: AssetImage('images/GreyMama.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Itty_Bitty.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Teddy.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Gaia.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Super Cal.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Ziggy.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Patches.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Pumpkin.webp'))),
            SizedBox(
                height: 150,
                width: 150,
                child: Image(image: AssetImage('images/Princess.jpeg'))),
              
            // add text
          ]
        )
      )
    );
  }

  Widget _verticalCatPics(double currentHeight) {
    return SizedBox(
      ////////////////////////// to have all cat pictures
      height: currentHeight - 370,
      width: 310,
      child: Scrollbar(
        /////// mini scroll for cat pics
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
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/GreyMama.webp'))),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Itty_Bitty.webp'))),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Teddy.webp'))),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Gaia.webp'))),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Super Cal.webp'))),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Ziggy.webp'))),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Patches.webp'))),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Pumpkin.webp'))),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('images/Princess.jpeg'))
                )
              ],
            )
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
    _nestedTabController =
        TabController(length: 4, vsync: this); // length: 4 = 4 tabs
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
    //  min window is 500, max is 1536 for my device
    {
      if (screenWidth < 900) {
        containerWidth = screenWidth - 50;
        containerHeight = (-0.5*screenWidth) + 900;
      } else {
        containerWidth = 850;
        containerHeight = 450;
      }
    }

    return Container( // contains the tabs, wont take entire screen
      height: containerHeight,
      width: containerWidth,
      color: const Color.fromARGB(255, 202, 202, 202),
      child: Column(
        children: [
          TabBar( // tabs; must match length of TabController(length: 4, vsync: this)
            tabAlignment: TabAlignment.center,
            controller: _nestedTabController, // controller that controls tabs
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54, // change to grey
            isScrollable: true,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Playfair Display"),
            tabs: const [ ///////////////// the tab options, length must match
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
              Tab(icon: Icon(Icons.local_dining), text: 'Sign Up To Feed'),
              Tab(icon: Icon(Icons.account_box), text: 'Account'),
            ],
          ),
          SizedBox(
            // contents of tabs
            height: containerHeight - 100,
            width: containerWidth - 80,
            child: TabBarView(
              //////////////////////////what is contained in each tab, must match TabBar length
              controller: _nestedTabController, // same controller
              children: [
                ////////////////////////////////////////////////////////////////// HOME PAGE
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                          'The Home page is where users will defualt towards when loging in.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                    const Text('Here you can view the current time slots filled in for the next few days.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    const Text('Along with that, 2 other things are visible:.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    const Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'News: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'This is where any important updates that the admins send out will be visible. It can be removed by pressing the "x" button', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Achievements: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'This simply keeps track of the number of times you have volutneered to feed the cats. Let this be a good personal motivation to continue feeding them.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    const Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    const Text('Make sure to regularly log in to see if there are any new updates or if there are open slots available.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                  ],
                ),
                /////////////////////////////////////////////////////////////////// ADMIN PAGE
                Column( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                          'This page is only available to those that have been granted admin permissions. Only Cat Partners officers will be granted this permission and be able to manage various functions related this website.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'On this page, Admins can do the following:', 
                            style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                          ]
                        )
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('- Edit the status of an account or delete an account', style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display'), textAlign: TextAlign.left,))
                      ]
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('- Add new admins and remove old admins based on the current roster of Cat Partners officers', style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display'), textAlign: TextAlign.left,))
                      ]
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('- Edit cat and station information, such as what cats are active on campus and where', style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display'), textAlign: TextAlign.left,))
                      ]
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('- Add or remove feeding stations based on cat activity', style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display'), textAlign: TextAlign.left,))
                      ]
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('- Export data that shows total amount of volunteer hours and who volunteered', style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display'), textAlign: TextAlign.left,))
                      ]
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0,0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'With that said, please do not abuse the privilege you have with managing this site.', 
                            style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                          ]
                        )
                      ),
                    ),
                  ],
                ),
                ///////////////////////////////////////////////////////////// FEEDER PAGE
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('The Sign up to Feed page is where you can officially volutenteer to feed cats.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
                    Text('It will display all currently avaiable slots as well as already-filled-in slots.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text('The names of others users will be displayed here as well.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text('When signing up for a slot, click on the time slot of your choice. After making sure it is the correct time slot, press submit.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),

                  ],
                ),
                /////////////////////////////////////////////////////////// ACCOUNT PAGE
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('The Account page is where information about you is stored.', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center),
                    ),
                    const Text('Some of this information is based on your Google account and others are based on your input.', style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center,),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Text('This website keeps the following information about you:', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'A method of communication and the way you sign into the website. Due to various reasons, you are not able to change this without creating a new account.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'This is what other people will see on the feeding sign up and home page. Please use your first name or preferred name.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Phone Number: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'Another method of contact visible only to admins.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Status: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'Your current relation with the school (student, alumnai, parent of student, etc.). ', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Rescure Group Afflilation: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'If you are part of a rescue group, you can add this to your account.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0,0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'Make sure all the information here is up-to-date and accurate and that you press submit to lock in any changes.', 
                            style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                          ]
                        )
                      ),
                    ),
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
