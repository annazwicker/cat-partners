import "package:flutter/material.dart";

// Done by Marlon Mata 
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( // basis of structure
        body: SingleChildScrollView(
          child: Center( 
            child: Column(  // starts widgets from top and goes down
              // puts each individual widget on a separate "line" -> Title, boxes, tabs
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('About This Site', 
                          style: TextStyle(fontWeight: FontWeight.bold, height: 2, fontSize: 30 )),
                // puts things side to side
                Wrap(///////////////////////////////////////////////////// Wrap-to handle small screens
                  spacing: 70,
                  runSpacing: 40,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: [
                    Stack(// box + text overlayed on top of each other
                      alignment: Alignment.center,
                      children: [
                        Container(// for color box
                          height: 390,
                          width: 390,
                          color: Color(0xFFFFCD00)
                        ),
                        // help position text, Positioned only works with Stack
                        Positioned(//////////////////////////////////////// Positioned - to position text
                          child: Container(//////////////////////////////// Container - to enclose text
                            height: 370,
                            width: 370,
                            child: Column(///////////////////////////////// Column - help align text
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their official SU website page(link here).', 
                                  style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // color box
                        Container(
                          height: 390,
                          width: 390,
                          color: Color(0xFFFFCD00)
                        ),
                        // help position text, Positioned only works with Stack
                        Positioned(
                          child: Container(
                            height: 370,
                            width: 370,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('    This site was created during the Spring semester of 2024 as part of a Computer Science Capstone project. Along with input from Cat Partners, the following individuals have worked on making this site a reality:', 
                                  style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0))),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 70,
                          child: Container(
                            height: 80,
                            width: 70,
                            color: Color(0xFF000000)
                          )
                        ),
                        Positioned(
                          top: 110,
                          right: 70,
                          child: Container(
                            height: 80,
                            width: 70,
                            color: Color(0xFF000000)
                          )
                        )
                      ],
                    ) 
                  ]
                )
              ]
            )
          ),
        )
      )
    );
  }
}
