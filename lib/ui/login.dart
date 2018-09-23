import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    return new SignUpPageState();
  }

  final LoginBLoC bLoC = LoginBLoC();
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bLoC.isLoggingIn,
      initialData: false,
      builder: (_, snapshotIsLoggingIn) => Scaffold(
            appBar: AppBar(title: Text("Sign Up")),
            body: Stack(
              children: snapshotIsLoggingIn.data
                  ? [_buildPagedView(), _buildOpacityOverlay()]
                  : [_buildPagedView()],
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: snapshotIsLoggingIn.data ? null : () => null,
                      icon: Icon(Icons.arrow_back),
                      label: Text("Log In")),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: snapshotIsLoggingIn.data ? null : () => null,
              child: Icon(FontAwesomeIcons.check),
            ),
          ),
    );
  }

  Widget _buildPagedView() {
    return StreamBuilder<PageController>(
      initialData: PageController(initialPage: 0),
      stream: widget.bLoC.pageControllerData,
      builder: (_, snapshotPageController) => PageView(
            children: <Widget>[
              _buildLoginFromFacebook(),
              ErrorViewWidget(),
            ],
            physics: NeverScrollableScrollPhysics(),
            controller: snapshotPageController.data,
          ),
    );
  }

  Widget _buildOpacityOverlay() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  Widget _buildLoginFromFacebook() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.network(
              "https://northlakeshotel.com.au/wp-content/uploads/2018/05/facebook-icon-preview-1.png",
              fit: BoxFit.contain,
              height: 200.0,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () => widget.bLoC.logInToFacebook.add(true),
          child: Text("Login", style: TextStyle(color: Colors.white)),
          color: Color.fromARGB(255, 71, 89, 147),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.bLoC.dispose();
  }
}

class TextBoxWidget extends StatefulWidget {
  @override
  TextBoxWidgetState createState() => TextBoxWidgetState();

  TextBoxWidget({
    @required this.icon,
    @required this.onSubmit,
    @required this.changeApplyFunc,
    this.helperText,
    this.hintText,
    this.isPassword = false,
    this.invalidText = "",
    this.maxLines = 1,
  });

  final IconData icon;
  final Function onSubmit;
  final Function changeApplyFunc;
  final String helperText;
  final String hintText;
  final bool isPassword;
  final String invalidText;
  final int maxLines;
}

/// Builds a text box.
/// **Unknown reason causing adding a controller to clear text box when unfocused.**
/// So will use [onChange] to record changes.
/// So need to pass a function that will change outer variable value.
class TextBoxWidgetState extends State<TextBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          icon: CircleAvatar(child: Icon(widget.icon)),
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.invalidText != "" ? widget.invalidText : null,
        ),
        obscureText: widget.isPassword,
        onSubmitted: (s) => widget.onSubmit(),
        onChanged: widget.changeApplyFunc,
      ),
    );
  }
}
