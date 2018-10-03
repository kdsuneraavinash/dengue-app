import 'package:flutter/material.dart';

class ErrorViewer extends StatelessWidget {
  final Object error;
  final Function function;

  const ErrorViewer(this.error, this.function);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(
          dismissible: false,
          color: Colors.red[600],
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  error.toString(),
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
}
