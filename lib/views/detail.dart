import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:convert';
import '../store/api.dart';
import '../modules/detail/detailModel.dart';
import '../store/index.dart';

class Detail extends StatefulWidget {
    final String id;

    Detail(_id) : this.id = _id;

    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return new _DetailState();
    }
}

class _DetailState extends State<Detail> {
    DetailItem detailItem;

    _reqData({@required String item_id, VoidCallback complete}) {
        var httpClient = new HttpClient();
        var url = Uri.parse(Api.detailData + item_id);
        return httpClient
            .getUrl(url)
            .then((HttpClientRequest request) {
            return request.close();
        }).then((HttpClientResponse response) {
            response.transform(utf8.decoder).join().then((contents) {
//                print('detail内容：${contents}');
                print('detail数据长度：${contents.length}');
                var data = json.decode(contents);
                if (data['code'] == 200) {
                    setState(() {
                        detailItem = DetailItem.fromJson(data['data']);
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
        print('初始化');
        super.initState();
        _reqData(item_id: widget.id);
    }

    @override
    Widget build(BuildContext context) {
        GModel gModel = ScopedModel.of<GModel>(context,rebuildOnChange: true);
        gModel.setNum(15);


        // TODO: implement build

        return new Theme(
            data: Theme.of(context).copyWith(primaryColorBrightness: Brightness.dark),
            child: new Material(
                child: new SafeArea(
                    child: new Padding(
                        padding: new EdgeInsets.all(15.0),
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                new Text(
                                    detailItem?.title ?? gModel.num.toString(),
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.ltr,
                                    style: new TextStyle(
                                        fontSize: 24.0
                                    ),
                                ),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                    ],
                                )
                            ],
                        ),
                    )
                )
            )

        );

    }
}