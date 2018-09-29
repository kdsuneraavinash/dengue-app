import 'dart:async';

import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/feed_provider.dart';
import 'package:dengue_app/providers/home_provider.dart';
import 'package:dengue_app/providers/login_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/home_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:intro_slider/intro_slider.dart';

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
    if (mounted) {
      loginBLoC = LoginBLoCProvider.of(context);
      userBLoC = UserBLoCProvider.of(context);
      loginBLoC.signUpStatusUpdateStream
          .listen(userBLoC.signUpFinishedSink.add);
      userBLoC.logInStateStream.listen(loginBLoC.loginStatusChangedSink.add);
      loginBLoC.goToTabPageStream.listen(_handleChangeTabPage);
      loginBLoC.navigateToHomePageStream.listen(_handleNavigateToHomePage);
      //userBLoC.loginIfAlreadyLoggedIn();
    }
  }

  @override
  void dispose() {
    loginBLoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LogInState>(
        stream: userBLoC.logInStateStream,
        initialData: LogInState.WAITING,
        builder: (_, snapshotIsLoggingIn) => Stack(
              children: snapshotIsLoggingIn.data == LogInState.WAITING
                  ? [_buildMainView(), _buildLoadingView()]
                  : [_buildMainView()],
            ));
  }

  Widget _buildMainView() {
    return Scaffold(
      body: _buildPagedView(),
    );
  }

  Widget _buildPagedView() {
    return PageView(
      children: <Widget>[
        _buildLoginScreen(),
        _buildAdditionalInfoView(),
        IntroductionView(
          () => loginBLoC.submitSink.add(1),
          () => loginBLoC.submitSink.add(1),
        ),
      ],
      physics: NeverScrollableScrollPhysics(),
      controller: widget._pageController,
    );
  }

  Widget _buildLoadingView() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: ModalBarrier(
              dismissible: false, color: Theme.of(context).primaryColor),
        ),
        Center(
          child: HeartbeatProgressIndicator(
            child: Icon(
              FontAwesomeIcons.globe,
              color: Colors.white,
              size: 70.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginScreen() {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: DefParameterNetworkImage(
              imageUrl: "http://www.logodust.com/img/free/logo26.png",
              isCover: false,
              needProgress: false,
              width: screenSize.width / 1.5,
              height: screenSize.width / 1.5,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: screenSize.width / 1.5,
                child: RaisedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  onPressed: () => userBLoC.firestoreAuthCommandSink
                      .add(LogInCommand.GOOGLE_LOGIN),
                  label: Text(
                    "Google Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red[800],
                ),
              ),
              SizedBox(
                width: screenSize.width / 1.5,
                child: RaisedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.facebookSquare,
                    color: Colors.white,
                  ),
                  onPressed: () => userBLoC.firestoreAuthCommandSink
                      .add(LogInCommand.FACEBOOK_LOGIN),
                  label: Text(
                    "Facebook Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xff3B5998),
                ),
              ),
            ],
          ),
        )
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
                  changeApplyFunc: loginBLoC.changeFullNameSink.add,
                  maxLines: 1,
                  hintText: "Full Name",
                  helperText: "Enter your Full Name with initials here.",
                ),
                TextBoxWidget(
                  icon: Icons.location_city,
                  onSubmit: (_) {},
                  changeApplyFunc: loginBLoC.changeAddressSink.add,
                  maxLines: 3,
                  hintText: "Address",
                  helperText: "Enter your Address here.",
                ),
                TextBoxWidget(
                  icon: Icons.call,
                  onSubmit: (_) {},
                  changeApplyFunc: loginBLoC.changeTelephoneSink.add,
                  maxLines: 1,
                  hintText: "Phone Number",
                  helperText: "Enter your Personal Contact here.\n"
                      "This number will be used later in order to contact you.",
                  keyBoardType: TextInputType.phone,
                ),
                Container(
                  padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      loginBLoC.submitSink.add(0);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            );
          } else {
            return ErrorViewWidget();
          }
        },
      ),
    );
  }

  void _handleNavigateToHomePage(_) {
    if (mounted) {
      TransitionMaker.fadeTransition(
          destinationPageCall: () =>
              HomePageBLoCProvider(child: FeedBLoCProvider(child: HomePage())))
        ..startReplace(context);
    }
  }

  void _handleChangeTabPage(int page) async {
    await Future.delayed(Duration(seconds: 1));
    if (page != null && mounted && widget._pageController.hasClients) {
      widget._pageController.animateToPage(page,
          duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
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
/// So need to pass a function that will change outer variable value.
class TextBoxWidgetState extends State<TextBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: widget.keyBoardType ?? TextInputType.text,
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

class IntroductionView extends StatefulWidget {
  @override
  _IntroductionViewState createState() => _IntroductionViewState();

  IntroductionView(this.skipPressed, this.donePressed);

  final VoidCallback skipPressed;
  final VoidCallback donePressed;
}

class _IntroductionViewState extends State<IntroductionView> {
  List<Slide> slides = List();

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "WELCOME",
        description:
            "Welcome to Dengue Free Zone App. Click NEXT to learn more.",
        pathImage: "images/logo.jpg",
        backgroundColor: 0xff607D8B,
      ),
    );
    slides.add(
      Slide(
        title: "FREE DATA",
        description:
            "Earn free data.... We gift free data to 100 each week and you can easily be one of them.",
        pathImage: "images/data.png",
        backgroundColor: 0xffb71c1c,
      ),
    );
    slides.add(
      Slide(
        title: "FREE GIFTS",
        description:
            "We present gifts for three users each week. Be one of them and earn amazing gifts.",
        pathImage: "images/gifts.png",
        backgroundColor: 0xff203152,
      ),
    );
    slides.add(
      Slide(
        title: "CLEAN",
        description:
            "The only task you have to do is to clean your environment and update us with your progress.",
        pathImage: "images/clean.png",
        backgroundColor: 0xff4A148C,
      ),
    );
    slides.add(
      Slide(
        title: "DEFEND AGAINST DENGUE",
        description:
            "Defend yourself against dengue. Why not join us and earn free gifts while cleaning your own garden?",
        pathImage: "images/mosquito.png",
        backgroundColor: 0xff004D40,
      ),
    );
  }

  void onDonePress() {
    widget.donePressed();
  }

  void onSkipPress() {
    widget.skipPressed();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}
