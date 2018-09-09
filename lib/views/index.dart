// 首页
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import '../store/api.dart';
import '../modules/newModel.dart';
import '../modules/newsList.dart';

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    var _newsDataList = <NewsItem>[];

    // 进行数据请求
    _reqList() {
        var httpClient = new HttpClient();
        httpClient.getUrl(Uri.parse(Api.newsList)).then((
            HttpClientRequest request) {
            return request.close();
        }).then((HttpClientResponse response) {
            response.transform(utf8.decoder).listen((contents) {
//                print(contents);
                var data = json.decode(contents);
                if (data['code'] == 200) {
                    List<dynamic> list = data['data'];
                    var tmpList = <NewsItem>[];
                    list.forEach((item) {
                        var newsItem = NewsItem.fromJson(item);
//                         print(newsItem.title);
                        tmpList.add(newsItem);
                    });
                    setState(() {
                        _newsDataList = tmpList;
                    });
                }
            });
        }).catchError((error) {
            print(error);
        }).whenComplete(() {

        });
    }

    @override
    Widget build(BuildContext context) {
//        设置状态栏
        SystemChrome.setSystemUIOverlayStyle(
            new SystemUiOverlayStyle(
                statusBarColor: new Color(0x00ffffff),

            )
        );
        _reqList();

        return new Scaffold(
            appBar: new AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: new Text(widget.title, textAlign: TextAlign.center),
                backgroundColor: const Color(0xffd43d3d),
                centerTitle: true,
                actions: <Widget>[
                    new IconButton(
                        icon: const Icon(Icons.search, size: 26.0),
                        onPressed: () {
                            // todo

                        }
                    )
                ],
            ),
            body: new Column(
                children: <Widget>[
                    new Container(
                        height: 300.0,
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: new NewsList(listData: _newsDataList),
                    )
                ],
            ),
        );
    }
}