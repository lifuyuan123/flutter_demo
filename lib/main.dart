import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_one/camera.dart';
import 'package:flutter_one/login.dart';
import 'package:flutter_one/page.dart';
import 'package:flutter_one/web.dart'; //导入material ui组件


//main 函数中调用了runApp 方法，它的功能是启动Flutter应用。runApp它接受一个 Widget参数，
// 在本示例中它是一个MyApp对象，MyApp()是 Flutter 应用的根组件。
void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp()); //应用入口

  FlutterNativeSplash.remove();
}

//应用入口
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 相当于application 设置应用属性
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,//设置状态栏颜色
              statusBarBrightness:Brightness.light//设置沉浸式第一步
          )
      );
    }
    return MaterialApp(
      title: 'Flutter Demo', //应用名称
      routes: <String, WidgetBuilder>{
        "goPage": (context) => const TwoPage(title: "nasdf"),

      },
      builder: (context,child)=>Scaffold(//用于全局隐藏软键盘
        body: GestureDetector(
          onTap: (){
            hideKeyboard(context);
          },
          child: child,//这里需要传入child
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue, //应用主题
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),//应用首页路由
      home: const TabboxA(), //应用首页路由
    );
  }

}

///隐藏软键盘
void hideKeyboard(BuildContext context){
  FocusScopeNode focus=FocusScope.of(context);
  if(!focus.hasPrimaryFocus&&focus.focusedChild!=null){
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class TwoPage extends StatelessWidget{
  final String title;
  const TwoPage({Key? key ,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     extendBodyBehindAppBar: true,//设置沉浸式第二步
     appBar:AppBar(title: Text(title)) ,
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children:const <Widget>[
           Text("特此")
         ]
       ),
     ),
   );
  }

}

//应用主页  StatefulWidget：它是一个有状态的组件
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPageState();

  final String title;
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "wojiuasdfasdfasdf",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Text("34524523452345"),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const platForm=MethodChannel('com.example.flutter_one/jump_plugin');

  //flutter跳转原生页面
  void _goTwo() async {
    String result= await platForm.invokeMethod('goTwo');
    print(result);
  }

  //flutter传递参数给原生
  void _sendData() async{
    Map<String,String> map={"flutter":"我是flutter传递过来的数据"};
    String result= await platForm.invokeMethod('getData',map);
    print(result);
  }

  @override
  void initState() {
    super.initState();
    platForm.setMethodCallHandler(_platformCallHandler);
  }

  Future<dynamic> _platformCallHandler (MethodCall call) async {
    switch(call.method){
      case 'goPage':
        print('原生传过来的数据：${call.arguments}');


        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const MyHomePage(title: "原生点机跳转",);
            })
        );


        return Future.value('原生点机跳转的哦');
      default :
        print('没有找到该方法call.method');
        throw MissingPluginException();
        break;
    }
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  //构建ui的方法  每次调用setState时，都会重新运行此方法
  @override
  Widget build(BuildContext context) {
    //Scaffold 是 Material 库中提供的页面脚手架，它提供了默认的导航栏、标题和包含主屏幕 widget 树（后同“组件树”或“部件树”）的body属性，
    // 组件树可以很复杂。
    return Scaffold(
      appBar: AppBar(
        //标题
        title: Text(widget.title),
      ),
      body: Center(
        //一个组件(相当于viewGroup)
        child: Column(
          //相当于linerlayout 竖向
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text('点击跳转Two页面'),
              onPressed: (){
                print("跳转two");
                _goTwo();
              },
            ),
            TextButton(
              child: const Text('点击传递数据给原生'),
              onPressed: (){
                print("传递数据");
                _sendData();
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, //相当于点击事件  触发对应函数
        tooltip: 'Increment', //长按提示该文字
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TabboxA extends StatefulWidget {
  const TabboxA({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabboxAState();
}

class _TabboxAState extends State<TabboxA> {
  bool _active = false;

  void handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            color: _active ? Colors.lightGreen[700] : Colors.grey[600]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _active ? "active" : "inactive",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            TextButton(
              child: const Text("跳转"),
              onPressed: (){
                  Navigator.push(
                  context,
                      CupertinoPageRoute(builder: (context) {
                    // return const MyHomePage(title: "点击跳转过来的",);
                    return const DataListPage();
                  })
                );

              },

            ),
              TextButton(
                child: const Text("相机"),
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return  const CameraPage(type: 0,);
                      })
                  );
                },
              ),
              TextButton(
                child: const Text("选择图片"),
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return  const CameraPage(type: 1,);
                      })
                  );
                },
              ),
              TextButton(
                child: const Text("web"),
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return  const WebPage();
                      })
                  );
                },
              ),
              TextButton(
                child: const Text("login"),
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return  const LoginPage();
                      })
                  );
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}
