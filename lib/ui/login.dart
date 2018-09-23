import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
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
    return StreamBuilder<LogInProgress>(
      stream: widget.bLoC.logInState,
      initialData: LogInProgress.NOT_LOGGED,
      builder: (_, snapshotIsLoggingIn) => Scaffold(
            appBar: AppBar(title: Text("Sign Up")),
            body: Stack(
              children: snapshotIsLoggingIn.data == LogInProgress.WAITING
                  ? [_buildPagedView(), _buildOpacityOverlay()]
                  : [_buildPagedView()],
            ),
            bottomNavigationBar: snapshotIsLoggingIn.data ==
                    LogInProgress.LOGGED
                ? BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FlatButton.icon(
                          onPressed: () => widget.bLoC.issueSocialMediaCommand
                              .add(LogInCommand.LOGOUT),
                          icon: Icon(Icons.arrow_back),
                          label: Text("Log Out"),
                        ),
                      ],
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton:
                snapshotIsLoggingIn.data == LogInProgress.LOGGED
                    ? FloatingActionButton(
                        onPressed: () => null,
                        child: Icon(FontAwesomeIcons.check),
                      )
                    : null,
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
              _buildAdditionalInfoView(),
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
          child: ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  Widget _buildLoginFromFacebook() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: DefParameterNetworkImage(
              imageUrl: "http://www.logodust.com/img/free/logo26.png",
              isCover: false,
              height: screenWidth / 2,
              width: screenWidth / 2,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth / 1.5,
          child: RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.google, color: Colors.white),
            onPressed: () => widget.bLoC.issueSocialMediaCommand
                .add(LogInCommand.GOOGLE_LOGIN),
            label: Text("Google Login", style: TextStyle(color: Colors.white)),
            color: Colors.red[800],
          ),
        ),
        SizedBox(
          width: screenWidth / 1.5,
          child: RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
            onPressed: () => widget.bLoC.issueSocialMediaCommand
                .add(LogInCommand.FACEBOOK_LOGIN),
            label:
                Text("Facebook Login", style: TextStyle(color: Colors.white)),
            color: Color.fromARGB(255, 71, 89, 147),
          ),
        ),
        SizedBox(
          width: screenWidth / 1.5,
          child: RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.twitter, color: Colors.white),
            onPressed: () => widget.bLoC.issueSocialMediaCommand
                .add(LogInCommand.TWITTER_LOGIN),
            label: Text("Twitter Login", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Card(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Notice\n\n"
                    "To use 'Page Public Content Access',"
                    " this app has to be reviewed and approved by Facebook."
                    "So Facebook Login feature is currently disabled.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, letterSpacing: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAdditionalInfoView() {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth / 15),
            child: ClipOval(
              child: DefParameterNetworkImage(
                imageUrl:
                    "https://graph.facebook.com/100002491783271/picture?type=large",
                isCover: false,
                height: screenWidth / 3,
                width: screenWidth / 3,
              ),
            ),
          ),
        ),
        TextBoxWidget(
          icon: Icons.location_city,
          onSubmit: (_) {},
          maxLines: 3,
          hintText: "Address",
          helperText: "Enter your Address Here.",
        ),
        TextBoxWidget(
          icon: Icons.call,
          onSubmit: (_) {},
          maxLines: 1,
          hintText: "Phone Number",
          helperText: "Enter your Personal Contact Here.\n"
              "This number will be used later in order to contact you.",
        ),
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
    this.changeApplyFunc,
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
        onSubmitted: widget.onSubmit,
        onChanged: widget.changeApplyFunc ?? (_) {},
      ),
    );
  }
}
