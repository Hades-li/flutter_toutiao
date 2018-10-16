import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Browser extends StatefulWidget {
    final String url;

    Browser(this.url);

    @override
    BrowserState createState() => new BrowserState();
}

class BrowserState extends State<Browser> {
    Future<Null> _launched;

    Future<Null> _launchInBrowser(String url) async {
        if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false, forceWebView: false);
        } else {
            throw 'Could not launch $url';
        }
    }

    Future<Null> _launchInWebViewOrVC(String url) async {
        if (await canLaunch(url)) {
            await launch(url, forceSafariVC: true, forceWebView: true);
        } else {
            throw 'Could not launch $url';
        }
    }

    Future<Null> _launchInWebViewWithJavaScript(String url) async {
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

    Widget _launchStatus(BuildContext context, AsyncSnapshot<Null> snapshot) {
        if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
        } else {
            return const Text('');
        }
    }

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        return null;
    }
}