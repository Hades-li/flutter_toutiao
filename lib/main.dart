import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'modules/globe.dart';
import 'routes/index.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    Router createRouter() {
        Application.router = new Router();
        Routes.configureRoutes(Application.router);
        return Application.router;
    }
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: '今日头条',
            theme: new ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
                // counter didn't reset back to zero; the application is not restarted.
                primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            onGenerateRoute: createRouter().generator,
//            home: new MyHomePage(title: '首页'),
        );
    }
}

