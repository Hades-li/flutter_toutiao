// 首页
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import '../store/api.dart';
import '../modules/newModel.dart';
import '../modules/newsList.dart';

class TabTitle {
    TabTitle(this.title, this.id);

    String title;
    int id;
}

List<TabTitle> tabList = [
    new TabTitle('推荐', 0),
    new TabTitle('热门', 1),
];

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
    var _newsDataList = <NewsItem>[];
    TabController _tabController;

    // 请求数据
    _reqList() {
        var httpClient = new HttpClient();
        httpClient
            .getUrl(Uri.parse(Api.newsList))
            .then((HttpClientRequest request) {
            return request.close();
        }).then((HttpClientResponse response) {
            response.transform(utf8.decoder).join().then((contents) {
                print('json数据长度：${contents.length}');
                var data = json.decode(contents);
                if (data['code'] == 200) {
                    print(data['data']);
                    var list = data['data'];
                    var tmpList = <NewsItem>[];
                    list.forEach((item) {
                        var newsItem = NewsItem.fromJson(item);
                        tmpList.add(newsItem);
                    });
                    setState(() {
                        _newsDataList = tmpList;
                    });
                }
            });
        }).catchError((error) {
//            print(error);
        }).whenComplete(() {});
    }

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        _tabController = new TabController(length: tabList.length, vsync: this);
        _reqList();
    }

    @override
    void dispose() {
        // TODO: implement dispose
        super.dispose();
        _tabController.dispose();
    }

    @override
    Widget build(BuildContext context) {
//        设置状态栏
        SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
            statusBarColor: new Color(0x00ffffff),
        ));

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
                        })
                ],
            ),
            body: new Column(
                children: <Widget>[
                    new Container(
                        color: new Color(0xfff4f5f6),
                        height: 38.0,
                        child: new TabBar(
                            indicatorColor: const Color(0xfff4f5f6), // 下面线的颜色
                            labelColor: Colors.red, // 标签文字颜色
                            unselectedLabelColor: const Color(0xff666666),
                            controller: _tabController,
                            tabs: tabList.map((item) {
                                return new Tab(
                                    child: new Text(
                                        item.title
                                    ),
                                );
                            }).toList()
                        ),
                    ),
                    new Expanded(
                        child: new Container(
                            padding: new EdgeInsets.only(
                                left: 20.0, right: 20.0),
                            child: new NewsList(listData: _newsDataList),
                        ))
                ],
            )
        );
    }
}
