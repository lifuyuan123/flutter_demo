import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/Bean.dart';

/// 列表页面
class DataListPage extends StatefulWidget {
  const DataListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DataListState();
  }
}

class DataListState extends State<DataListPage>
    with AutomaticKeepAliveClientMixin {
  ///滑动控件
  ScrollController scrollController = ScrollController();

  var lists = []; //数据
  var isload = false; //是否正在加载

  ///获取数据源
  Future<void> getData({bool isloadMore = false}) async {
    isload = true;
    var urls = "https://imgapi.cn/cos.php?return=jsonpro";

    try {
      Response response = await Dio().get(urls);
      print(response.toString());

      Map<String, dynamic> jsons = json.decode(response.toString());
      var datas = Bean.fromJson(jsons);
      LogUtil.e(lists);

      if (datas.imgurls != null && datas.imgurls!.isNotEmpty) {
        setState(() {
          if (isloadMore) {
            lists.addAll(datas.imgurls!);
            // lists = [...lists, datas.imgurls];
            LogUtil.e("加载更多$lists");
          } else {
            lists = datas.imgurls!;
            LogUtil.e("首页加载$lists");
          }
        });
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        isload = false;
      });
    } catch (e) {
      isload = false;
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //滑动监听
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;

      //滑到底部不足300且没有加载时
      if (dis < 300 && !isload) {
        getData(isloadMore: true);
      }
    });
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    //释放资源
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('列表'),
          leading: IconButton(
            icon: const Icon(Icons.back_hand),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: getData,
          child: ListView.builder(
            itemCount: lists.length,
            itemBuilder: itemView,
            controller: scrollController, //滑动控件
          ),
        ));
  }

  Widget itemView(BuildContext context, int index) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          color: Colors.lightGreen,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                Column(
                  children: <Widget>[
                    Text('adfaddfasdfasdf$index'),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(lists[index]),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ConstrainedBox(
                  constraints: const BoxConstraints.expand(
                      width: double.infinity, height: 200),
                  child: Image.network(
                    //网图加载
                    lists[index],
                    fit: BoxFit.cover,
                  ),
                )
              ]),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
