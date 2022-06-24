

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  final int type;
  const CameraPage({Key? key,required this.type}) : super(key: key);


  @override
  State<StatefulWidget> createState() => CameraState();
}

class CameraState extends State<CameraPage> {


   File? image;
  final picker=ImagePicker();//图片引擎

  //获取图片
  Future choosePic(ImageSource source) async {
    //获取图片
    final pickedFile=await picker.getImage(source:source);

    setState((){
      if(pickedFile!=null){
        image=File(pickedFile.path);
      }else{
        print('图片为空');
      }
    });

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(widget.type==0?'拍照':'选择图片'),
       centerTitle: true,
     ),
     body: Center(
       child: image==null?const Text('没有数据'):Image.file(image!),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         choosePic(widget.type==0?ImageSource.camera:ImageSource.gallery);
       },
       tooltip: widget.type==0?'拍照':'选择图片',
       child: Icon(widget.type==0?Icons.add_a_photo:Icons.photo_library),
     ),
   );
  }

}
