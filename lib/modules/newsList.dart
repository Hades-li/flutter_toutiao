import 'package:flutter/material.dart';
import '../modules/newModel.dart';
import 'globe.dart';
import 'package:flutter_image/network.dart';
import 'package:fluro/fluro.dart';

class NewsList extends StatefulWidget {
    final List<NewsItem> newsDataList;
    final RefreshCallback pullRefresh;

    NewsList({@required List<NewsItem> listData, this.pullRefresh}) : newsDataList = listData;

    @override
    _NewsState createState() => new _NewsState();
}

class _NewsState extends State<NewsList> {
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
    Widget build(BuildContext context) {
        // 第一种cell
        Function cellItem_0 = ({int index, NewsItem item}) {
            return new FlatButton(
//                splashColor: Colors.blue,
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                onPressed: () {
                    String _id = item.item_id;
                    // push到详情页
                    Application.router.navigateTo(context, '/detail/$_id',transition: TransitionType.inFromRight);
                },
                child:  new Container (
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: new BoxDecoration(
                        border: index != 0 ? new Border(
                            top: new BorderSide(color: new Color(0xff000000))
                        ) : null
                    ),
                    child: new Container(
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                new Container( // 左侧内容
                                    width: 200.0,
                                    child: new Column(
                                        children: <Widget>[
                                            new Text(
                                                item.title,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: const Color(0xff333333),
                                                ),
                                            ),
                                            new Row(
                                                children: <Widget>[
                                                    new Container(
                                                        decoration: new BoxDecoration(
                                                            border: new Border.all(
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
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.start,
                                    ),
                                ),
                                new Container( // 图片item
                                    width: 114.0,
                                    height: 74.0,
                                    color: const Color(0xff666666),
                                    child: () {
                                        if (item.image_url != null) {
                                            print(item.image_url);
                                            return new Image(
                                                image: new NetworkImageWithRetry(item.image_url),
                                            );
                                        } else {
                                            return null;
                                        }
                                    }()
                                )
                            ],
                        ),
                    )
                )
            );

        };

        // TODO: implement build
        return new RefreshIndicator(
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
            ),
            onRefresh: widget.pullRefresh != null ? widget.pullRefresh : null
        );
    }
}