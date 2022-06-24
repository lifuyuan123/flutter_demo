package com.example.flutter_one

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class TwoActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_two)
    }

    fun goFlutter(view: View){

        startActivity(FlutterActivity
            .withNewEngine()
            .initialRoute("goPage")
            .build(this)
        )


//        FlutterPlugin.channel.invokeMethod("goPage","from android",object : MethodChannel.Result{
//            override fun success(p0: Any?) {
//                Log.e("MainActivity","原生调用flutter success$p0")
//            }
//
//            override fun error(p0: String, p1: String?, p2: Any?) {
//                Log.e("MainActivity","原生调用flutter error")
//            }
//
//            override fun notImplemented() {
//                Log.e("MainActivity","原生调用flutter notImplemented")
//            }
//
//        })
    }
}