import "package:flutter/material.dart";

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( // basis of structure
        body: Center( // helps keeps things centered
          child: Column(  // starts widgets from top and goes down
            // puts each individual widget on a separate "line" -> Title, boxes, tabs
            children: [Text('About This Site', 
                        style: TextStyle(fontWeight: FontWeight.bold, height: 2, fontSize: 30 )),
              // puts things side to side
              Row( 
                children: [
                  Container(
                      height: 390,
                      width: 90,
                      color: Color.fromARGB(255, 255, 255, 255)
                    ),
                  // used to overlay text over color box
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
                              Text('    This site is the official Cat Partners Feeding website. This site is meant to help manage the feeding locations and times for the members of Cat Partners and other volunteers.\n    Cat Partners is an official Southwestern University student organization charged with caring for the community cats on campus. To learn more about them and how to support them, go to their official SU website page(link here).', 
                                style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)))
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ]
              )
            ]
          )
        ),
      )
    );    
  }
}
