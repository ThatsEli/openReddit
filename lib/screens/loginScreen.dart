import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:redditclient/screens/homeScreen.dart';
import 'package:redditclient/services/redditService.dart';
import 'package:redditclient/tools/LoginAppBrowser.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool error = false;
  String errorText = '';
  String errorReason = '';
  String state = randomAlphaNumeric(16);
  LoginAppBrowser loginAppBrowser;

  @override
  void initState() { 
    this.loginAppBrowser = new LoginAppBrowser();
    this.loginToReddit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: this.error ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(this.errorText + ' '),
                      Text(this.errorReason),
                      ButtonTheme(
                        child: RaisedButton(
                          child: Text('Retry'),
                          onPressed: () {
                            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) { return LoginScreen(); }));
                          },
                        ),
                      )
                    ],
                  ) : Container(),
              )
              ,
            )
          )
        ],
      ),
    );
  }

  void loginToReddit() {
    RedditService.reddit = Reddit.createInstalledFlowInstance(
      clientId: 'yG99FCjMF8tXaA',
      userAgent: randomAlphaNumeric(10),
      redirectUri: Uri.parse('https://thatseliyt.de/')
    );

    final String authUrl = RedditService.reddit.auth.url(['*'], this.state, compactLogin: true).toString();
    this.loginAppBrowser.setCallbacks(
      codeCallback: (String code) {
        this.confirmRedditLogin(code);
      },
      errorCallback: (String errorReason) {
        setState(() {
          this.error = true;
          this.errorText = 'Error while authenticating, please try again.';
          this.errorReason = errorReason;
        });
      },
      state: this.state
    );
    this.loginAppBrowser.open(
      url: authUrl,
      options: {
        'transparentBackground': true,
        'toolbarTop': false
      }
    );
  }

  void confirmRedditLogin(String code) async {
    try {
      await RedditService.reddit.auth.authorize(code);
    } catch (e) {
      this.loginAppBrowser.close();
      setState(() {
        this.error = true;
        this.errorText = 'Error while authenticating! Please try again'; 
      });
      return;
    }
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) { return HomeScreen(); }));
  }

}

