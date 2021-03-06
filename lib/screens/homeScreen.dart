import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:openReddit/screens/loginScreen.dart';
import 'package:openReddit/screens/profileScreen.dart';
import 'package:openReddit/screens/searchScreen.dart';
import 'package:openReddit/screens/subredditScreen.dart';
import 'package:openReddit/services/redditService.dart';
import 'package:openReddit/services/settingsService.dart';
import 'package:openReddit/widgets/submissionsWidget.dart';

import 'settingsScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Submission> _submissions = [];
  List<Subreddit> _subscribedSubreddits = <Subreddit>[];

  @override
  void initState() {
    
    this.loadFrontpage();
    this.loadSubscribedSubreddits();
    super.initState();
  }

  void loadFrontpage() async {
    setState(() {
      this._submissions = [];
    });
    try {
      RedditService.reddit.front.best().listen((submission) {
        if(this.mounted) {
          setState(() {
            this._submissions.add(submission);
          });
        }
      });
    } catch (e) {
      SettingsService.setKey('redditCredentials', ''); SettingsService.save();
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) { return LoginScreen(); }));
    }
  }

  void loadPopular() async {
    setState(() {
      this._submissions = [];
    });
    RedditService.reddit.front.top(timeFilter: TimeFilter.day).listen((submission) {
      setState(() {
        this._submissions.add(submission);
      });
    });
  }

  void loadSaved() async {
    setState(() {
      this._submissions = [];
    });
    Redditor me = await RedditService.reddit.user.me();
    me.saved().listen((submission) {
      setState(() {
        if(submission is Submission)
        this._submissions.add(submission);
      });
    });
  }

  void loadSubscribedSubreddits() {
    RedditService.reddit.user.subreddits().listen((Subreddit subreddit) {
      setState(() {
        this._subscribedSubreddits.add(subreddit);
        this._subscribedSubreddits.sort((a, b) => a.displayName.compareTo(b.displayName));
      });
    });
    return;
  }

    
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget> [
            // DrawerHeader(
            //   child: Text('Reddit'),
            //   margin: EdgeInsets.all(0),
            // ),
            FutureBuilder(
              future: RedditService.reddit.user.me(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  Redditor me = snapshot.data;
                  return ListTile(
                    title: Text(me.displayName ?? 'Loading...'),
                    trailing: RaisedButton(
                      child: Text('Logout'),
                      onPressed: () {
                        SettingsService.setKey('redditCredentials', '');
                        SettingsService.save();
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) { return LoginScreen(); }));
                      },
                    ),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) { return ProfileScreen(redditor: snapshot.data); }));
                    },
                  );
                } else return ListTile(title: Text('Loading...'));
              },
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                setState(() {
                  this._submissions = null;
                });
                Navigator.pop(context);
                this.loadFrontpage();
              },
            ),
            ListTile(
              title: Text('Popular'),
              onTap: () {
                setState(() {
                  this._submissions = null;
                });
                Navigator.pop(context);
                this.loadPopular();
              },
            ),
            ListTile(
              title: Text('Search'),              
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) { return SearchScreen(); }));
              },
            ),
            ListTile(
              title: Text('Saved'),
              onTap: () {
                setState(() {
                  this._submissions = null;
                });
                Navigator.pop(context);
                this.loadSaved();
              },
            ),
            Divider(),
            this._subscribedSubreddits != null ?
              Expanded(child: ListView.builder(
                itemCount: this._subscribedSubreddits.length,
                addAutomaticKeepAlives: true,
                cacheExtent: 10,
                itemBuilder: (BuildContext context, int index) {
                  if(this._subscribedSubreddits[index] != null) {
                    if(this._subscribedSubreddits[index].iconImage != null && this._subscribedSubreddits[index].iconImage.toString() != '')  {
                      return ListTile(
                        title: Text('r/' + this._subscribedSubreddits[index].displayName ?? 'Error while loading'),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                _subscribedSubreddits[index].iconImage.toString().contains('/avatars/') ?
                                'https://www.redditstatic.com' + _subscribedSubreddits[index].iconImage.toString()
                                : _subscribedSubreddits[index].iconImage.toString()
                              )
                            )
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) { return SubredditScreen(subreddit: this._subscribedSubreddits[index]); }));
                        },
                      );
                    }
                    else return ListTile(
                      title: Text('r/' + this._subscribedSubreddits[index].displayName ?? 'Error while loading'),
                      leading: Container(
                        width: 40,
                        height: 40,
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) { return SubredditScreen(subreddit: this._subscribedSubreddits[index]); }));
                      },
                    ); 
                  } else return Container(width: 0, height: 0);
                }
              )) 
            : ListTile(title: Text('Loading...')),
            Divider(),
            ListTile(
              title: Text('Settings & About'),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) { return new SettingsScreen(); }));
              },
            ),
          ],
        )
      ),
      appBar: AppBar(
        title: Text('Reddit'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: this._submissions.length > 0 ?
          SubmissionsWidget(submissions: this._submissions) : LinearProgressIndicator(),
      ),
    );
  }
    
}