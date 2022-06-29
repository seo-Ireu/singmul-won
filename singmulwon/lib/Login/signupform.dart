import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm(
      this.useridTextController,
      this.passwordTextController,
      this.nicknameTextController,
      this.phoneTextController,
      this.profileintroTextController,
      this.parentAction);

  final TextEditingController useridTextController;
  final TextEditingController passwordTextController;
  final TextEditingController nicknameTextController;
  final TextEditingController phoneTextController;
  final TextEditingController profileintroTextController;

  final ValueChanged<List<dynamic>> parentAction;

  @override
  State<StatefulWidget> createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm>
    with AutomaticKeepAliveClientMixin<SignUpForm> {
  bool _agreedToTerm = false;

  void _setAgreedToTerm(bool newValue) {
    _passDataToParent('term', newValue);
    setState(() {
      _agreedToTerm = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(13.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 360,
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.perm_identity,
                  ),
                  labelText: 'Id',
                  hintText: 'Type your Id'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Id is required';
                } else {
                  return null;
                }
              },
              controller: widget.useridTextController,
            ),
          ),
          Divider(),
          SizedBox(
            width: 360,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Type password'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Password is required';
                } else {
                  return null;
                }
              },
              controller: widget.passwordTextController,
            ),
          ),
          Divider(),
          Divider(),
          SizedBox(
            width: 360,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.badge),
                  labelText: 'Nickname',
                  hintText: 'Type Nickname'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Nickname is required';
                } else {
                  return null;
                }
              },
              controller: widget.nicknameTextController,
            ),
          ),
          Divider(),
          SizedBox(
            width: 360,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.phone),
                  labelText: 'Phone Number',
                  hintText: 'Type PhoneNum'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'PhoneNum is required';
                } else {
                  return null;
                }
              },
              controller: widget.phoneTextController,
            ),
          ),
          Divider(),
          SizedBox(
            width: 360,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.contact_page),
                  labelText: 'ProfileIntro',
                  hintText: 'Type Profile'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'ProfileIntro is required';
                } else {
                  return null;
                }
              },
              controller: widget.profileintroTextController,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _agreedToTerm,
                  onChanged: _setAgreedToTerm,
                ),
                GestureDetector(
                  onTap: () => _setAgreedToTerm(!_agreedToTerm),
                  child: const Text(
                    'I agree to Terms of Services, Privacy Policy',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _passDataToParent(String key, dynamic value) {
    List<dynamic> addData = List<dynamic>();
    addData.add(key);
    addData.add(value);
    widget.parentAction(addData);
  }

  @override
  bool get wantKeepAlive => true;
}
