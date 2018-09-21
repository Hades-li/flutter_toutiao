import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    @override
    void initState() {
        // TODO: implement initState
        print ('初始化');

        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        //        设置状态栏
        SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
            statusBarColor: new Color(0xff00ff00)
        ));
        return new Material(
            child: new Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: new Text('id号：${widget.id}'),
            )
        );
    }
}