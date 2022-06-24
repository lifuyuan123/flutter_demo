package com.example.flutter_one

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import io.flutter.view.FlutterMain

class TestActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterMain.startInitialization(this)
        setContentView(R.layout.activity_test)
    }

    fun goMain(view: View){
        startActivity(Intent(this,MainActivity::class.java))
    }
}