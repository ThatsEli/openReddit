import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:openReddit/screens/loginScreen.dart';
import 'package:openReddit/services/infoService.dart';
import 'package:openReddit/services/settingsService.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsService.init();
  InfoService.init();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => new ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black87
        ),
        brightness: brightness,
        canvasColor: brightness == Brightness.dark ? Color.fromRGBO(18, 18, 18, 1) : Colors.white,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'openReddit',
          theme: theme,
          home: LoginScreen()
        );
      }
    );
  }
}
