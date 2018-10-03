import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/loading_screen.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/login_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/error_handler_ui.dart';
import 'package:dengue_app/ui/home_ui.dart';
import 'package:dengue_app/ui/userdata_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_slider/intro_slider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBLoCProvider(
      child: LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatefulWidget {
  static const routeName = "/login";

  @override
  LoginPageContentState createState() {
    return LoginPageContentState();
  }

  final PageController _pageController = PageController(initialPage: 0);
}

class LoginPageContentState extends State<LoginPageContent> {
  LoginBLoC loginBLoC;
  UserBLoC userBLoC;
  StreamSubscription goToTabPageStreamSubscription,
      navigateToHomePageStreamSubscription;
  StreamSubscription signUpFinishedSubscription, loginStatusSubscription;

  @override
  void dispose() {
    super.dispose();
    navigateToHomePageStreamSubscription.cancel();
    goToTabPageStreamSubscription.cancel();
    signUpFinishedSubscription.cancel();
    loginStatusSubscription.cancel();
    loginBLoC.dispose();
    widget._pageController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      loginBLoC = LoginBLoCProvider.of(context);
      userBLoC = UserBLoCProvider.of(context);
      signUpFinishedSubscription = loginBLoC.signUpStatusUpdateStream
          .listen(userBLoC.signUpFinishedSink.add);
      loginStatusSubscription = userBLoC.logInStateStream
          .listen(loginBLoC.loginStatusChangedSink.add);
      goToTabPageStreamSubscription =
          loginBLoC.goToTabPageStream.listen(_handleChangeTabPage);
      navigateToHomePageStreamSubscription =
          loginBLoC.navigateToHomePageStream.listen(_handleNavigateToHomePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: userBLoC.exceptionStream,
      builder: (_, snapshotException) {
        return snapshotException?.data == null
            ? StreamBuilder<LogInState>(
                stream: userBLoC.logInStateStream,
                initialData: LogInState.WAITING,
                builder: (_, snapshotIsLoggingIn) {
                  List<Widget> children;
                  if (snapshotIsLoggingIn.data == LogInState.WAITING) {
                    children = [_buildPagedView(), _buildLoadingView()];
                  } else {
                    children = [_buildPagedView()];
                  }
                  return Stack(children: children);
                },
              )
            : ErrorViewer(snapshotException.data, userBLoC.exceptionStream.add);
      },
    );
  }

  Widget _buildPagedView() {
    return Scaffold(
      body: PageView(
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
      ),
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
          child: AnimatedLoadingScreen(AnimationFile.MaterialLoading),
        ),
      ],
    );
  }

  Widget _buildLoginScreen() {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
              "http://www.mobileswall.com/wp-content/uploads/2015/12/640-Quiet-Environment-l.jpg"),
        ),
      ),
      child: Opacity(
        opacity: 0.9,
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoView() {
    return StreamBuilder<User>(
        initialData: null,
        stream: userBLoC.userStream,
        builder: (_, snapshotUser) {
          if (snapshotUser != null) {
            return UserDataEditView(
              photo: snapshotUser.data?.photoUrl == null
                  ? User.BLANK_PHOTO
                  : snapshotUser.data.photoUrl,
              afterSubmit: _handleSubmitPressed,
            );
          } else {
            return ErrorViewWidget();
          }
        });
  }

  /// Texts Submitted Handler
  bool _handleSubmitPressed(String fullName, String address, String telephone) {
    String _fullName = fullName.trim();
    String _address = address.trim();
    String _telephone = telephone.trim();
    bool fullNameValid = _fullName.length != 0;
    bool addressValid = _address.length != 0;
    bool telephoneValid = _telephone.length != 0;

    if (fullNameValid && addressValid && telephoneValid) {
      userBLoC.signUpFinishedSink.add(<String, dynamic>{
        'telephone': _telephone,
        'fullName': _fullName,
        'address': _address
      });
      loginBLoC.submitSink.add(0);
      return true;
    }
    return false;
  }

  void _handleNavigateToHomePage(_) {
    if (mounted) {
      TransitionMaker.fadeTransition(destinationPageCall: () => HomePage())
        ..startReplace(context);
    }
  }

  void _handleChangeTabPage(int page) async {
    if (page != null && mounted && widget._pageController.hasClients) {
      widget._pageController.animateToPage(page,
          duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
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

    double width = MediaQuery.of(context).size.width / 1.5;
    double height = MediaQuery.of(context).size.width / 1.5;

    slides.add(
      Slide(
        title: "WELCOME",
        description:
            "Welcome to Dengue Free Zone App. Click NEXT to learn more.",
        pathImage: "images/mobile.png",
        backgroundColor: 0xff607D8B,
        widthImage: width,
        heightImage: height,
      ),
    );
    slides.add(
      Slide(
        title: "FREE DATA",
        description:
            "Earn free data.... We gift free data to 100 each week and you can easily be one of them.",
        pathImage: "images/data.png",
        backgroundColor: 0xffb71c1c,
        widthImage: width,
        heightImage: height,
      ),
    );
    slides.add(
      Slide(
        title: "FREE GIFTS",
        description:
            "We present gifts for three users each week. Be one of them and earn amazing gifts.",
        pathImage: "images/gifts.png",
        backgroundColor: 0xff203152,
        widthImage: width,
        heightImage: height,
      ),
    );
    slides.add(
      Slide(
        title: "CLEAN",
        description:
            "The only task you have to do is to clean your environment and update us with your progress.",
        pathImage: "images/clean.png",
        backgroundColor: 0xff4A148C,
        widthImage: width,
        heightImage: height,
      ),
    );
    slides.add(
      Slide(
        title: "DEFEND AGAINST DENGUE",
        description:
            "Defend yourself against dengue. Why not join us and earn free gifts while cleaning your own garden?",
        pathImage: "images/mosquito.png",
        backgroundColor: 0xff004D40,
        widthImage: width,
        heightImage: height,
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
