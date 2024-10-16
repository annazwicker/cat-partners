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
    return Column(children: [
      if (_isWindowOpen)
        Container(
          margin: const EdgeInsets.all(5),
          color: SUYellow,
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.3,
          constraints: BoxConstraints(
              minWidth: 300, minHeight: 250),
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
                    child: Builder(builder: (context) {
                      return Text(widget.message,
                          style: TextStyle(
                            fontSize: 16,
                          ));
                    })),
              ),
            )
          ]),
        ),
    ]);
  }
}
