import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
// import 'package:flutter_application_1/const.dart'; 
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
            // following puts images of cats in a scroll box
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
  // controls tabs
  late TabController _nestedTabController;
  // controls scrolling
  final ScrollController _tabVerticalOne = ScrollController();
  final ScrollController _tabVerticalTwo = ScrollController();
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
              Tab(icon: Icon(Icons.info), text: 'About'),
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
                          'The Home page is the default page users will be directed to upon logging in.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left),
                    ),
                    const Text("Here users can view the times they've signed up to feed for the next two weeks from the current day.", style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    // const Text('Along with that, 2 other things are visible:.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    const Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: '\u2022 Notifications: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: "In the notifications box, users can see any feeding stations that don't have anyone signed up to feed for the current day and the next day.", 
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
                                TextSpan(text: '\u2022 Achievements: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                TextSpan(text: 'This keeps track of the number of times you have volutneered to feed the campus cats.', 
                                style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                    const Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    const Text('Users should regularly log in to check when they are signed up to feed and see if there are any open slots available.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                  ],
                ),
                /////////////////////////////////////////////////////////////////// ADMIN PAGE
                SingleChildScrollView(
                  controller: _tabVerticalOne,
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                            'The admin page is only available to those that have been granted admin permissions. This page allows users to modify various aspects of the website and user accounts.',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(text: 'On this page, Admins can navigate through the different tabs. Listed below are the different features of these tabs:', 
                              style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                            ]
                          )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(text: '\u2022 Edit/delete user accounts. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "Admin users can edit a current user's SU affiliation by selecting from the dropdown menu. Current users can be deleted by entering the user's gmail address.", 
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
                                  TextSpan(text: '\u2022 Add admin users and revoke admin permissions. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "New admin users can be added by entering a gmail address. Current admin users can have their admin capabilities revoked by selecting from the dropdown menu.", 
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
                                  TextSpan(text: '\u2022 Add/delete campus cats. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "New cats can be added by entering their name and selecting the feeding station they are located at from a dropdown menu. Current campus cats can be deleted by selecting from a dropdwon menu.", 
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
                                  TextSpan(text: '\u2022 Add/delete feeding stations. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "New feeding stations can be added by entering their name. Current feeding stations can be deleted by selecting from a dropdwon menu.", 
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
                                  TextSpan(text: '\u2022 Search for a user. ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "Admin users can search for a user by entering their first and last name, and gmail address.", 
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
                                  TextSpan(text: '\u2022 Export data as a CSV file ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "for a given academic year (select the year from a dropdown menu) that shows each volunteer associated with Cat Partners, the number of hours they volunteered, and the total number of volunteer hours from everyone.", 
                                  style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                                ]
                              )
                            ),
                          ),
                        ]
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 15, 0,0),
                      //   child: RichText(
                      //     textAlign: TextAlign.center,
                      //     text: const TextSpan(
                      //       children: [
                      //         TextSpan(text: 'With that said, please do not abuse the privilege you have with managing this site.', 
                      //         style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                      //       ]
                      //     )
                      //   ),
                      // ),
                    ],
                  ),
                ),
                ///////////////////////////////////////////////////////////// FEEDER PAGE
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('The Sign Up to Feed page is where a user can sign up to feed the campus cats.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
                    Text('The page will display all currently available entries. Any entry already taken by a user will display its assigned user.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    //Text('The names of others users will be displayed here as well.', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text('', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                    Text("When signing up to feed, a user can select one or more empty entries. Clicking an empty entry will select it, and clicking the same entry will unselect it. When a user has their desired selection, they can press submit to confirm it, assigning themselves to all selected entries.", style: TextStyle(fontSize: 18),textAlign: TextAlign.center),

                  ],
                ),
                /////////////////////////////////////////////////////////// ACCOUNT PAGE
                SingleChildScrollView(
                  controller: _tabVerticalTwo,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('The Account page is where information about the user is stored.', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center),
                      ),
                      const Text("The users first and last name, gmail address, phone number, and profile picture will be automatically provided by their Google account.  All information on this page can be manually changed except for the user's gmail address.", style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center,),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Text("Below is a brief description of the user information stored in the website's database.", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)), textAlign: TextAlign.center,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(text: '\u2022 Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: 'This is what other people will see on the feeding sign up. Please use your first name or preferred name.', 
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
                                  TextSpan(text: '\u2022 Email: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "This is the gmail account the user will login in with. Admin users will be able to see the user's gmail address in case they need to contact them. If it is changed, future log in attempts should be made with that new email to avoid creating a new account.", 
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
                                  TextSpan(text: '\u2022 Phone Number: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
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
                                  TextSpan(text: '\u2022 SU Affiliation: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: "The user's current relation with the school (student, alumnai, parent of student, etc.). ", 
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
                                  TextSpan(text: '\u2022 Rescure Group Afflilation: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Playfair Display')),
                                  TextSpan(text: 'If the user is part of a rescue group, they can add this to their account.  If not, this field can remain empty.', 
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
                              TextSpan(text: 'Users should make sure all the information here is up-to-date and accurate and press submit to save any changes.', 
                              style: TextStyle(fontSize: 18, fontFamily: 'Playfair Display')),
                            ]
                          )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]
      )
    );
  }
}
