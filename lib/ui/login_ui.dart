import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/home_provider.dart';
import 'package:dengue_app/providers/login_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/home_ui.dart';
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
  LoginBLoC loginBLoC;
  UserBLoC userBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginBLoC = LoginBLoCProvider.of(context);
    userBLoC = UserBLoCProvider.of(context);
    loginBLoC.signUpStatusUpdate.listen(userBLoC.signUpFinished.add);
    userBLoC.logInState.listen(loginBLoC.loginStatusChanged.add);
    loginBLoC.goToTabPage.listen(_handleChangeTabPage);
    loginBLoC.navigateToHomePage.listen(_handleNavigateToHomePage);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LogInState>(
      stream: userBLoC.logInState,
      initialData: LogInState.NOT_LOGGED,
      builder: (_, snapshotIsLoggingIn) => Scaffold(
            appBar: AppBar(title: Text("Sign Up")),
            body: Stack(
              children: snapshotIsLoggingIn.data == LogInState.WAITING
                  ? [_buildPagedView(), _buildOpacityOverlay()]
                  : [_buildPagedView()],
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  snapshotIsLoggingIn.data == LogInState.SIGNED_UP
                      ? FlatButton.icon(
                          onPressed: () => userBLoC.firestoreAuthCommand
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
                (snapshotIsLoggingIn.data == LogInState.SIGNED_UP)
                    ? FloatingActionButton(
                        onPressed: () => loginBLoC.submit.add(null),
                        child: Icon(FontAwesomeIcons.forward),
                      )
                    : null,
          ),
    );
  }

  Widget _buildPagedView() {
    return PageView(
      children: <Widget>[
        _buildLoginFromGoogle(),
        _buildAdditionalInfoView(),
      ],
      physics: NeverScrollableScrollPhysics(),
      controller: widget._pageController,
    );
  }

  Widget _buildOpacityOverlay() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.yellow),
          ),
        )
      ],
    );
  }

  Widget _buildLoginFromGoogle() {
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
                userBLoC.firestoreAuthCommand.add(LogInCommand.LOGIN),
            label: Text("Google Login", style: TextStyle(color: Colors.white)),
            color: Colors.red[800],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoView() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<User>(
        initialData: null,
        stream: userBLoC.userStream,
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
                  changeApplyFunc: loginBLoC.changeFullName.add,
                  maxLines: 1,
                  hintText: "Full Name",
                  helperText: "Enter your Full Name with initials here.",
                ),
                TextBoxWidget(
                  icon: Icons.location_city,
                  onSubmit: (_) {},
                  changeApplyFunc: loginBLoC.changeAddress.add,
                  maxLines: 3,
                  hintText: "Address",
                  helperText: "Enter your Address here.",
                ),
                TextBoxWidget(
                  icon: Icons.call,
                  onSubmit: (_) {},
                  changeApplyFunc: loginBLoC.changeTelephone.add,
                  maxLines: 1,
                  hintText: "Phone Number",
                  helperText: "Enter your Personal Contact here.\n"
                      "This number will be used later in order to contact you.",
                  keyBoardType: TextInputType.phone,
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
    if (navigate != null && navigate && context != null) {
      TransitionMaker.fadeTransition(
          destinationPageCall: () => HomePageBLoCProvider(child: HomePage()))
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
    this.keyBoardType,
  });

  final IconData icon;
  final Function onSubmit;
  final Function changeApplyFunc;
  final String helperText;
  final String hintText;
  final bool isPassword;
  final String invalidText;
  final int maxLines;
  final TextInputType keyBoardType;
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
        keyboardType: widget.keyBoardType ?? TextInputType.phone,
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
