import 'package:flutter/material.dart';

class ErrorViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            "http://getdrawings.com/images/sad-puppy-drawing-36.jpg",
            width: MediaQuery.of(context).size.width / 3,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Sorry couldn't load this Page\nPlease check your Connection",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
