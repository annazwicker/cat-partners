import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
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
      home: Scaffold( // basis of structure
        body: SingleChildScrollView(
          controller: _vertical,
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: true,
            child: Center( 
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
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
                      color: const Color(0xFFFFFFFF)
                    ),
                    _buildHowToTabs(),
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
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their ', 
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))
                      ),
                      TextSpan(
                        text: 'official SU website page',
                        style: const TextStyle(
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
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))
                      )
                    ]
                  )
                ),
                Container(
                    height: 40,
                    width: 10,
                    color: const Color(0xFF828282)
                  ),
                SizedBox(
                  height: 100,
                  width: 340,
                  child: Scrollbar(
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
    // change - make boxes proportion change based on size
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
            children: [
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

  Widget _buildHowToTabs(){
    return Stack(
      children: [
        Container(
          height: 500,
          width: 850,
          color: const Color(0xFF828282),
          // child: TabBar(
          //   tabs: [
          //     Tab(icon: Icon(Icons.home), text: '1'),
          //     Tab(icon: Icon(Icons.person), text: '2'),
          //     Tab(icon: Icon(Icons.person), text: '3'),
          //     Tab(icon: Icon(Icons.person), text: '4'),
          //   ],
          // )
        ),
      ]
    );
  }
}