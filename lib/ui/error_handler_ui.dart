import 'package:flutter/material.dart';

class ErrorViewer extends StatelessWidget {
  final Object error;
  final Function function;

  const ErrorViewer(this.error, this.function);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.8,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  _formatString(error.toString()),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () => function(null),
                color: Colors.white,
                child: Text("Dismiss"),
              )
            ],
          ),
        ),
      ],
    );
  }

  String _formatString(String error) {
    return "Network Error Occured. Please Check your internet connection.\n\nIf the problem persists, contact developers.";
  }
}
