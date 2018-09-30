import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:flutter/material.dart';

class UserDataEditView extends StatefulWidget {
  UserDataEditView({Key key, this.afterSubmit, this.photo}) : super(key: key);

  @override
  _UserDataEditViewState createState() => _UserDataEditViewState();

  final Function afterSubmit;
  final String photo;
}

class _UserDataEditViewState extends State<UserDataEditView> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _telephone = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _fullName.dispose();
    _address.dispose();
    _telephone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth / 15),
              child: ClipOval(
                child: DefParameterNetworkImage(
                  imageUrl: widget.photo,
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
            maxLines: 1,
            hintText: "Full Name",
            helperText: "Enter your Full Name with initials here.",
            controller: _fullName,
            keyBoardType: TextInputType.text,
          ),
          TextBoxWidget(
            icon: Icons.location_city,
            onSubmit: (_) {},
            maxLines: 3,
            hintText: "Address",
            helperText: "Enter your Address here.",
            controller: _address,
            keyBoardType: TextInputType.text,
          ),
          TextBoxWidget(
            icon: Icons.call,
            onSubmit: (_) {},
            maxLines: 1,
            hintText: "Phone Number",
            helperText: "Enter your Personal Contact here.\n"
                "This number will be used later in order to contact you.",
            keyBoardType: TextInputType.phone,
            controller: _telephone,
          ),
          Container(
            padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
            child: RaisedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.afterSubmit(
                    _fullName.text, _address.text, _telephone.text);
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class TextBoxWidget extends StatefulWidget {
  @override
  TextBoxWidgetState createState() => TextBoxWidgetState();

  TextBoxWidget({
    @required this.icon,
    @required this.onSubmit,
    this.helperText,
    this.hintText,
    this.isPassword = false,
    this.invalidText = "",
    this.maxLines = 1,
    this.keyBoardType,
    this.controller,
  });

  final IconData icon;
  final Function onSubmit;
  final String helperText;
  final String hintText;
  final bool isPassword;
  final String invalidText;
  final int maxLines;
  final TextInputType keyBoardType;
  final TextEditingController controller;
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
        controller: widget.controller,
        obscureText: widget.isPassword,
        onSubmitted: widget.onSubmit,
      ),
    );
  }
}
