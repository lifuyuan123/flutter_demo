package com.example.flutter_one

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @Author admin
 * @Date 2022/6/17-10:30
 * @describe:
 */
class FlutterPlugin constructor(private val activity: FlutterActivity) : MethodChannel.MethodCallHandler {


    companion object {

        lateinit var channel: MethodChannel

        val CHANNEL = "com.example.flutter_one/jump_plugin"

        //通过此方法注册
        fun registerWith(flutterEngine: FlutterEngine, activity: FlutterActivity) {
            channel = MethodChannel(flutterEngine.dartExecutor, CHANNEL)
            val instance = FlutterPlugin(activity)
            //此通道上接收方法调用回调
            channel.setMethodCallHandler(instance)
        }
    }

    override fun onMethodCall(p0: MethodCall, p1: MethodChannel.Result) {
        //通过MethodCall可以回去参数和方法名，在寻找对应平台业务
        when(p0.method){
            "goTwo"->{//跳转页面
                Toast.makeText(activity, "goTwo", Toast.LENGTH_SHORT).show()
                activity.startActivity(Intent(activity,TwoActivity::class.java).apply {
                    putExtra("data",Bundle().apply { putString("data","我是传过去的数据") })
                })
                p1.success("跳转two  success  result")
            }
            "getData"->{//获取数据
                val data=p0.argument<String>("flutter")
                Log.e("获取flutter数据",data.toString())
                Toast.makeText(activity, data.toString(), Toast.LENGTH_SHORT).show()
                p1.success("获取数据  success  result")
            }
        }

    }

}