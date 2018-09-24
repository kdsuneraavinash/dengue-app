import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/login.dart';
import 'package:dengue_app/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage();

  static const routeName = "/login";

  @override
  SignUpPageState createState() {
    return new SignUpPageState();
  }

  final PageController _pageController = PageController(initialPage: 0);
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final bLoC = LoginBLoCProvider.of(context);
    bLoC.goToTabPage.listen(_handleChangeTabPage);
    bLoC.navigateToHomePage.listen(_handleNavigateToHomePage);

    return StreamBuilder<LogInProgress>(
      stream: bLoC.logInState,
      initialData: LogInProgress.NOT_LOGGED,
      builder: (_, snapshotIsLoggingIn) => Scaffold(
            appBar: AppBar(title: Text("Sign Up")),
            body: Stack(
              children: snapshotIsLoggingIn.data == LogInProgress.WAITING
                  ? [_buildPagedView(context, bLoC), _buildOpacityOverlay()]
                  : [_buildPagedView(context, bLoC)],
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  snapshotIsLoggingIn.data == LogInProgress.LOGGED
                      ? FlatButton.icon(
                          onPressed: () => bLoC.issueSocialMediaCommand
                              .add(LogInCommand.LOGOUT),
                          icon: Icon(Icons.arrow_back),
                          label: Text("Log Out"),
                        )
                      : FlatButton.icon(
                          onPressed: () => null,
                          icon: Icon(FontAwesomeIcons.globe),
                          label: Text("Visit our page"),
                        ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton:
                snapshotIsLoggingIn.data == LogInProgress.LOGGED
                    ? FloatingActionButton(
                        onPressed: () => bLoC.submit.add(context),
                        child: Icon(FontAwesomeIcons.check),
                      )
                    : null,
          ),
    );
  }

  Widget _buildPagedView(BuildContext context, LoginBLoC bLoC) {
    return PageView(
      children: <Widget>[
        _buildLoginFromFacebook(bLoC),
        _buildAdditionalInfoView(bLoC),
      ],
      physics: NeverScrollableScrollPhysics(),
      controller: widget._pageController,
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

  Widget _buildLoginFromFacebook(LoginBLoC bLoC) {
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
            onPressed: () =>
                bLoC.issueSocialMediaCommand.add(LogInCommand.GOOGLE_LOGIN),
            label: Text("Google Login", style: TextStyle(color: Colors.white)),
            color: Colors.red[800],
          ),
        ),
        SizedBox(
          width: screenWidth / 1.5,
          child: RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
            onPressed: () {},
            label:
                Text("Facebook Login", style: TextStyle(color: Colors.white)),
            color: Color.fromARGB(255, 71, 89, 147),
          ),
        ),
        SizedBox(
          width: screenWidth / 1.5,
          child: RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.twitter, color: Colors.white),
            onPressed: () {},
            label: Text("Twitter Login", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Notice\n\n"
                    "Facebook and Twitter logins are currently disabled due to app reviewing process. ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, letterSpacing: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAdditionalInfoView(LoginBLoC bLoC) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<User>(
        initialData: null,
        stream: bLoC.userStream,
        builder: (_, snapshotUser) {
          if (snapshotUser != null) {
            return ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth / 15),
                    child: ClipOval(
                      child: DefParameterNetworkImage(
                        imageUrl: snapshotUser.data == null ||
                                snapshotUser.data.photoUrl == null
                            ? User.BLANK_PHOTO
                            : snapshotUser.data.photoUrl,
                        isCover: false,
                        height: screenWidth / 3,
                        width: screenWidth / 3,
                      ),
                    ),
                  ),
                ),
                TextBoxWidget(
                  icon: Icons.person,
                  onSubmit: (_) {},
                  changeApplyFunc: bLoC.changeFullName.add,
                  maxLines: 1,
                  hintText: "Full Name",
                  helperText: "Enter your Full Name with initials here.",
                ),
                TextBoxWidget(
                  icon: Icons.location_city,
                  onSubmit: (_) {},
                  changeApplyFunc: bLoC.changeAddress.add,
                  maxLines: 3,
                  hintText: "Address",
                  helperText: "Enter your Address here.",
                ),
                TextBoxWidget(
                  icon: Icons.call,
                  onSubmit: (_) {},
                  changeApplyFunc: bLoC.changeTelephone.add,
                  maxLines: 1,
                  hintText: "Phone Number",
                  helperText: "Enter your Personal Contact here.\n"
                      "This number will be used later in order to contact you.",
                ),
              ],
            );
          } else {
            return ErrorViewWidget();
          }
        },
      ),
    );
  }

  void _handleNavigateToHomePage(bool navigate) {
    if (navigate && context != null) {
      TransitionMaker.fadeTransition(destinationPageCall: () => HomePage())
        ..startReplace(context);
    }
  }

  void _handleChangeTabPage(int page) {
    if (page != null && widget._pageController.hasClients) {
      widget._pageController.animateToPage(page,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
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
