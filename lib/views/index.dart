// 首页
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../store/api.dart';
import '../modules/newModel.dart';
import '../modules/newsList.dart';
import '../utils/http.dart';


// tab的数据模型
class TabTitle {
    String title;
    int id;
    List<NewsItem> listData = [];
    NewsController controller;
    GlobalKey<NewsState> key;
    TabTitle(this.title, this.id, [list])
        :this.listData = list ?? <NewsItem>[],
        this.key = new GlobalKey(),
        this.controller = new NewsController();
}

class Abc {
    int num;
    List<int> list = [];
    Abc(this.num,[list]);
}

List<TabTitle> tabList = [
    new TabTitle('推荐', 10),
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

    TabController _tabController;
    GlobalKey<NewsState> newsStateKey = new GlobalKey();
    bool isBottomRefresh = false;
    bool isRefreshing = false;

    // dio请求数据
    Future reqData({@required int index}) {
        final dio = createDio();
        final url = Api.getUrl(type: index, ms: new DateTime.now().millisecond);
        print(url);
        return dio.get(url).then((res) {
            if (res.data['return_count'] > 0 ) {
                var list = res.data['data'];
                var tmpList = <NewsItem>[];
                list.forEach((item) {
                    var newsItem = NewsItem.fromJson(item);
                    tmpList.add(newsItem);
                });
                print('list长度：${tmpList.length}');
                return tmpList;
            } else {
                throw new Exception('404');
            }
        });
    }

    Future nextTick() {
        return new Future.delayed(new Duration(milliseconds: 1), () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                return null;
            });
        });
    }

    @override
    void initState() {
        // TODO: implement initState
        // 首次渲染完成的回调
        _tabController = new TabController(length: tabList.length, vsync: this);
        nextTick().then((_) {
            print('父节点渲染完成');
//            print(tabList[_tabController.index].controller);
        });
        _tabController.addListener(() {
            if (_tabController.indexIsChanging == false) {
                if (tabList[_tabController.index].listData != null && tabList[_tabController.index].listData.length == 0) {
                    nextTick().then((_) {
                        print('切换完毕');
                        tabList[_tabController.index].controller.refresh();
                    });
                }
            }
        });

        super.initState();
    }
    
    @override
    void didUpdateWidget(MyHomePage oldWidget) {
        // TODO: implement didUpdateWidget
        super.didUpdateWidget(oldWidget);
    }

    @override
    void dispose() {
        // TODO: implement dispose
        super.dispose();
        _tabController.dispose();
    }

    @override
    Widget build(BuildContext context) {
        // 构建新闻列表
        /*_newsList = new NewsList(
            key: newsStateKey,
            listData: _newsDataList,
            isAutoRefresh: true,
            isBottomRefreshing: isBottomRefresh,
            pullRefresh: () {
                if (isRefreshing == false) {
                    isRefreshing = true;
                    return reqData(index: tabList[_tabController.index].id).then((list){
                        setState(() {
                            _newsDataList = list;
                        });
                    }).catchError((onError) {
                        throw new Exception('404');
                    }).whenComplete(() {
                        isRefreshing = false;
                        return null;
                    });
                }
            },
            bottomOffsetChange: (double offset) {
                print(offset);
                if (isBottomRefresh == false && isRefreshing == false) {
                    setState(() {
                        isBottomRefresh = true;
                    });
                    reqData(index: tabList[_tabController.index].id).then((list) {
                        setState(() {
                            _newsDataList.addAll(list);
                        });
                    }).catchError((onError){

                    }).whenComplete(() {
                        setState(() {
                            isBottomRefresh = false;
                        });
                    });
                }

            },
        );*/

        TabBarView _tabNewsList = new TabBarView(
            key: newsStateKey,
            controller: _tabController,
            children: tabList.map((item) {
//                print('列表是否为空:${item.listData}');
                return new NewsList(
                    key: item.key,
//                    isAutoRefresh: true,
                    listData: item.listData,
                    isBottomRefreshing: isBottomRefresh,
//                    controller: item.controller,
                    pullRefresh: () {
                        if (isRefreshing == false) {
                            isRefreshing = true;
                            int index = _tabController.index;
                            return reqData(index: tabList[index].id).then((list){
                                setState(() {
                                    tabList[index].listData = list;
                                });
                            }).catchError((onError) {
                                throw new Exception('404');
                            }).whenComplete(() {
                                isRefreshing = false;
                                return null;
                            });
                        } else {
                            return Future<void>(() => null);
                        }
                    },
                    bottomOffsetChange: (double offset) {
                        print(offset);
                        if (isBottomRefresh == false && isRefreshing == false) {
                            setState(() {
                                isBottomRefresh = true;
                            });
                            final index = _tabController.index;
                            reqData(index: tabList[index].id).then((list) {
                                setState(() {
                                    tabList[index].listData.addAll(list);
                                });
                            }).catchError((onError){

                            }).whenComplete(() {
                                setState(() {
                                    isBottomRefresh = false;
                                });
                            });
                        }
                    },
                );
            }).toList(),
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
                            child: _tabNewsList,
                        ))
                ],
            )
        );
    }
}
