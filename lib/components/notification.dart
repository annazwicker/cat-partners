import "package:flutter/material.dart";
import 'package:flutter_application_1/const.dart';


class NotificationBox extends StatefulWidget {
  final String message;
  const NotificationBox({required this.message});

  @override
  State<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  var _isWindowOpen = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isWindowOpen)
        IntrinsicHeight(
              child: Container(
                // margin: const EdgeInsets.all(0),
                color: SUYellow,
                width: MediaQuery.of(context).size.width * 0.75,
                // height: MediaQuery.of(context).size.height * 0.08,
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.08),
                child: Column(children: [
                  //x button
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
                  //text content
                  Expanded(
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 45, left: 20, right: 20),
                          child: Builder(
                            builder: (context) {
                              return Text(
                                  widget.message);
                            }
                          )),
                    ),
                  )
                ]),
              ),
            ),]
    );
  }
}
