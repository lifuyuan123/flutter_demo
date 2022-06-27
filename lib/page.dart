import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/Bean.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  var isLoadMore= false;

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
            isLoadMore=false;
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
      setState((){
        isLoadMore = false;
      });
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
        setState((){
          isLoadMore = true;
        });
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
      body: RefreshIndicator(onRefresh: getData, child: getParent()
          // ListView.builder(
          //   itemCount: lists.length,
          //   itemBuilder: itemView,
          //   controller: scrollController, //滑动控件
          // ),
          ),
      bottomNavigationBar: Container(
        height: isLoadMore?50:0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text('加载更多')],
          ),
        ),
      )
    );
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

  Widget getParent() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      staggeredTileBuilder: (index) =>
          StaggeredTile.count(2, index == 0 ? 2.5 : 3),
      //cross axis cell count
      mainAxisSpacing: 8,
      // vertical spacing between items
      crossAxisSpacing: 8,
      // horizontal spacing between items
      crossAxisCount: 4,
      // no. of virtual columns in grid
      itemCount: lists.length,
      itemBuilder: (context, index) => buildImageCard(index),
      controller: scrollController,
    );
  }

  Widget buildImageCard(int index) => Card(
        color: Colors.white,
        // margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
            margin: const EdgeInsets.all(4),
            child: Stack(
              children: [
                Image.network(
                  //网图加载
                  lists[index],
                  fit: BoxFit.cover,
                  height: 5000, //此处不强制指定宽高，图片显示不正确
                  width: 5000,
                ),
                Positioned(
                  //确定位置
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    lists[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Positioned(
                  //确定位置
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    "${lists[index]}"
                        .replaceAll("https://img.m4a1.top/imgapi.cn/", ""),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            )),
      );

  @override
  bool get wantKeepAlive => true;
}
