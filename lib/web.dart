

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget{
  const WebPage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState()=>WebState();

}

class WebState extends State<WebPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('web'),centerTitle: true,),
      body: const WebView(
        initialUrl:'https://www.baidu.com/' ,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

}