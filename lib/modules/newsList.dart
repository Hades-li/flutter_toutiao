import 'package:flutter/material.dart';
import '../modules/newModel.dart';
import 'dart:async';
import 'globe.dart';
import 'package:flutter_image/network.dart';
import 'package:fluro/fluro.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatefulWidget {
    final List<NewsItem> newsDataList;
    final RefreshCallback pullRefresh;
    final Function bottomOffsetChange;
    final bool isAutoRefresh; // 是否自动加载
    final bool isBottomRefreshing; // 底部是否正在加载，用于标记状态

    NewsList({
        Key key,
        @required List<NewsItem> listData,
        this.isAutoRefresh = false,
        this.pullRefresh,
        this.bottomOffsetChange,
        this.isBottomRefreshing = false
    })
        : newsDataList = listData,
            super(key: key);

    @override
    NewsState createState() => new NewsState();
}

class NewsState extends State<NewsList> {
    RefreshController _refreshController;
    ScrollController _control;
    LoadConfig loadConfig;

    String get bottomText => widget.isBottomRefreshing ? '正在更新' : '已经到底';


    String imgUrl(String url) {
        String imageUrl;
        if (url != null) {
            imageUrl = url.replaceFirst(new RegExp(r'list'), 'list/pgc-image');
        } else {
            return null;
        }
        return imageUrl;
    }

    void refresh() {
//        _refreshController.sendBack(true, RefreshStatus.idle);
//        _refreshController.scrollTo(100.0);
        _refreshController.requestRefresh(true);
    }

    Future<Null> launchInWebViewWithJavaScript(String url) async {
        if (await canLaunch(url)) {
            await launch(
                url,
                forceSafariVC: true,
                forceWebView: true,
                enableJavaScript: true,
            );
        } else {
            throw 'Could not launch $url';
        }
    }

    @override
    void initState() {
        // TODO: implement initState
        loadConfig = new LoadConfig(
            autoLoad: false
        );
        _refreshController = new RefreshController();

        _control = new ScrollController();
        _control.addListener(() {
            print('已到底部');

            if (_control.position.pixels ==
                _control.position.maxScrollExtent) {}
        });
//        判断是否自动刷新
        if (widget.isAutoRefresh) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                new Future.delayed(new Duration(milliseconds: 1), () {
                    refresh();
                });
            });
        }

        super.initState();
        print('子类init');
    }

    @override
    Widget build(BuildContext context) {
        // 第一种cell
        MaterialButton cellItem_0({int index, NewsItem item}) =>
            new MaterialButton(
                splashColor: Colors.transparent, // 水波纹透明
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                onPressed: () {
                    String _id = item.item_id;
                    // push到详情页
                    if (item.article_type == 1) { // 判断是广告
                        launchInWebViewWithJavaScript('http://google.com');
                    } else {
                        Application.router.navigateTo(context, '/detail/$_id',
                            transition: TransitionType.inFromRight);
                    }
                },
                child: new Container (
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: new BoxDecoration(
                        border: index != 0 ? new Border(
                            top: new BorderSide(color: new Color(0xfff6f6f6))
                        ) : null
                    ),
                    child: new Container(
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: () {
                                List<Widget> list = [];
                                list.add(new Expanded( // 左侧内容
                                    child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: () {
                                            List<Widget> list = [];
                                            list.add(
                                                new Text(
                                                    item.title,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 18.0,
                                                        color: const Color(
                                                            0xff333333),
                                                    ),
                                                )
                                            );
                                            if (item.image_list != null &&
                                                item.image_list.length > 0) {
                                                list.add(
                                                    new Padding(
                                                        padding: const EdgeInsets
                                                            .only(top: 10.0,
                                                            bottom: 10.0),
                                                        child: new Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            children: () {
                                                                return item.image_list.map((imageItem) => new Expanded(
                                                                    child: new Container(
                                                                        decoration: const BoxDecoration(
                                                                            border: Border(
                                                                                left: BorderSide(
                                                                                    width: 1.0,
                                                                                    color: Colors.white
                                                                                ),
                                                                                right: BorderSide(
                                                                                    width: 1.0,
                                                                                    color: Colors.white
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        child: new Image(
                                                                            fit: BoxFit
                                                                                .cover,
//                                                                        width: 120.0,
//                                                                        height: 80.0,
                                                                            image: new NetworkImageWithRetry(
                                                                                imageItem['url'])
                                                                        )
                                                                    )
                                                                )
                                                                ).toList();
                                                            }()
                                                        )
                                                    )
                                                );
                                            }
                                            list.add(
                                                new Row(
                                                    children: <Widget>[
                                                        item.hot == 1
                                                            ? new Container(
                                                            decoration: new BoxDecoration(
                                                                border: new Border
                                                                    .all(
                                                                    color: new Color(
                                                                        0xfffdd3d3)
                                                                )
                                                            ),
                                                            child: new Text(
                                                                '热',
                                                                style: const TextStyle(
                                                                    fontSize: 8.0
                                                                ),
                                                            ),
                                                        )
                                                            : new Container(),
                                                        new Text(
                                                            '  ${item
                                                                .media_name ??
                                                                '广告' } 评论 ${item
                                                                .comment_count}',
                                                            style: const TextStyle(
                                                                fontSize: 12.0,
                                                                color: const Color(
                                                                    0xff666666)
                                                            ),
                                                        ),
                                                    ],
                                                )
                                            );
                                            return list;
                                        }(),
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                    ),
                                ));
                                if (item.image_url != null) {
                                    list.add(new SizedBox(
                                        width: 117.0,
                                        child: new Container(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: new Image(
                                                fit: BoxFit.cover,
                                                image: new NetworkImageWithRetry(
                                                    item.image_url),
                                            ),
                                        )
                                    )
                                    );
                                }
                                return list;
                            }()
                        )
                    )
                )
            );

        // 当列表为空时的cell
        errorWidget() =>
            new Center(
                heightFactor: 2.0,
                child: new Text('目前没有数据'),
            );
        // TODO: implement build
//        new RefreshIndicator(child: null, onRefresh: null)
        return new SmartRefresher(
            controller: _refreshController,
//            headerConfig: loadConfig,
            headerBuilder: (BuildContext context, int mode) {
                return new ClassicIndicator(
                    mode: mode,
                    idleText: '下拉刷新',
                    releaseText: '释放更新',
                    refreshingText: '正在加载',
                    completeText: '更新完成',
                    failedText: '加载失败',
                );
            },
            enablePullDown: true,
            onRefresh: (bool up) {
                if (up) {
                    widget.pullRefresh().then((_) {
                        _refreshController.sendBack(
                            true, RefreshStatus.completed);
                    }).catchError((err) {
                        _refreshController.sendBack(true, RefreshStatus.failed);
                    }).whenComplete(() {

                    });
                }
            },
            onOffsetChange: (bool up, double offset) {
                if (up) {

                } else {
                    // 判断是否滑到底部
                    widget.bottomOffsetChange(offset);
                }
            },
            child: widget.newsDataList.isEmpty ?
            new ListView(children: <Widget>[errorWidget()]) :
            new ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.newsDataList.length + 1,
                itemBuilder: (BuildContext context, int index) {
//                    print('index:$index');
                    if (index < widget.newsDataList.length) {
                        return cellItem_0(
                            index: index,
                            item: widget.newsDataList[index]
                        );
                    } else {
                        return new Container(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            color: Colors.white70,
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    new Offstage(
                                        offstage: !widget.isBottomRefreshing,
                                        child: new SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: new CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                            ),
                                        ),
                                    ),
                                    new Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                        ),
                                        child: new Text(bottomText),
                                    )
                                ],
                            )
                        );
                    }
                },
                controller: _control,
            )
        );
    }
}