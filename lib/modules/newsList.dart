import 'package:flutter/material.dart';
import 'dart:async';
import '../modules/newModel.dart';
import 'globe.dart';
import 'package:flutter_image/network.dart';
import 'package:fluro/fluro.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsList extends StatefulWidget {
    final List<NewsItem> newsDataList;
    final RefreshCallback pullRefresh;

    NewsList({@required List<NewsItem> listData, this.pullRefresh})
        : newsDataList = listData;

    void refresh() {
        print('空');
    }

    @override
    NewsState createState() => new NewsState();
}

class NewsState extends State<NewsList> {
    RefreshController _refreshController;
    LoadConfig loadConfig;

    void refresh() {
        _refreshController.sendBack(true, RefreshStatus.idle);
        _refreshController.scrollTo(100.0);
        _refreshController.requestRefresh(true);
    }

    String imgUrl(String url) {
        String imageUrl;
        if (url != null) {
            imageUrl = url.replaceFirst(new RegExp(r'list'), 'list/pgc-image');
        } else {
            return null;
        }
        return imageUrl;
    }

    @override
    void initState() {
        print('子类init');
        // TODO: implement initState
        loadConfig = new LoadConfig(
            autoLoad: true
        );
        _refreshController = new RefreshController();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        print('子build');
        // 第一种cell
        Widget cellItem_0({int index, NewsItem item}) => new MaterialButton(
                splashColor: const Color(0x000000),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                onPressed: () {
                    String _id = item.item_id;
                    // push到详情页
                    Application.router.navigateTo(context, '/detail/$_id',
                        transition: TransitionType.inFromRight);
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
                                                                return item
                                                                    .image_list
                                                                    .map((
                                                                    imageItem) =>
                                                                new SizedBox(
                                                                    child: new Image(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width: 120.0,
                                                                        height: 80.0,
                                                                        image: new NetworkImageWithRetry(
                                                                            imageItem['url'])
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
                                                        new Container(
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
                                                        ),
                                                        new Text(
                                                            '  ${item
                                                                .media_name} 评论 ${item
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

        // TODO: implement build
//        new RefreshIndicator(child: null, onRefresh: null)
        return new SmartRefresher(
            controller: _refreshController,
            headerConfig: loadConfig,
            enablePullDown: true,
            onRefresh: (bool up) {
                if (up) {
                    widget.pullRefresh().whenComplete(() {
                        _refreshController.sendBack(true, RefreshStatus.completed);
                    });
                }
            },
            child: new ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.newsDataList.length,
                itemBuilder: (BuildContext context, int index) {
                    if (index < widget.newsDataList.length) {
//                    print('index: $index');
//                    print('title: ${widget.newsDataList[index].title}');
                        return cellItem_0(
                            index: index,
                            item: widget.newsDataList[index]
                        );
                    } else {
                        return null;
                    }
                }
            )

        );
    }
}