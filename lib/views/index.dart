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
    new TabTitle('热点', 0),
    new TabTitle('社会', 1),
    new TabTitle('娱乐', 2),
    new TabTitle('体育', 3),
    new TabTitle('美文', 4),
    new TabTitle('科技', 5),
    new TabTitle('财经', 6),
    new TabTitle('时尚', 7)
];

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
    var _newsDataList = <NewsItem>[];
    NewsList _newsList;
    TabController _tabController;

    // 请求数据
    _reqList({@required String reqIndex, VoidCallback complete}) {
        var httpClient = new HttpClient();
        return httpClient
            .getUrl(Uri.parse(Api.newsList + reqIndex))
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
            print(error);
        }).whenComplete(() {

        });
    }
    @override
    void initState() {
        // TODO: implement initState
        //        设置状态栏
        /*SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
            statusBarColor: new Color(0xff00ff00),
        ));*/
        super.initState();
        _reqList(reqIndex: '0');
        _tabController = new TabController(length: tabList.length, vsync: this);
        _tabController.addListener(() {
            if (_tabController.indexIsChanging == false) {
                setState(() {
                    _newsDataList = [];
                });
                print(_newsList);
                if (_newsList != null) {
                    _newsList.pullRefresh();
                }
//                _reqList(reqIndex: tabList[_tabController.index].id.toString());
            }
        });
    }

    @override
    void dispose() {
        // TODO: implement dispose
        super.dispose();
        _tabController.dispose();
    }

    @override
    Widget build(BuildContext context) {
        _newsList = new NewsList(
            listData: _newsDataList,
            pullRefresh: () async {
                await _reqList(reqIndex: _tabController.index.toString());
            },
        );

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
                            isScrollable: true,
//                            indicatorColor: const Color(0xfff4f5f6), // 下面线的颜色
                            labelColor: Colors.red,
                            // 标签文字颜色
                            unselectedLabelColor: const Color(0xff666666),
                            labelStyle: const TextStyle(fontSize: 16.0),
                            controller: _tabController,
                            tabs: tabList.map((item) {
                                return new Tab(
                                    text: item.title,
                                );
                            }).toList()
                        ),
                    ),
                    new Expanded(
                        child: new Container(
                            padding: new EdgeInsets.only(left: 0.0, right: 0.0),
                            child: _newsList
                        ))
                ],
            )
        );
    }
}
