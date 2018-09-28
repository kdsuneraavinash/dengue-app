import 'package:flutter/material.dart';

/// Creates an Icon Text.
///
/// Main Color will be Primary Color.
/// Otherwise works as a normal text.
class IconText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: this.mainAxisAlignment,
        children: <Widget>[
          Icon(
            this.icon,
            color: Colors.white,
          ),
          SizedBox(
            height: 8.0,
            width: 8.0,
          ),
          Text(
            this.text,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.button.apply(color: Colors.white),
          ),
        ],
      ),
    );
  }

  IconText({this.icon, this.text, this.mainAxisAlignment});

  final IconData icon;
  final String text;
  final MainAxisAlignment mainAxisAlignment;
}