package com.brother.ptouch.sdk.printdemo

import android.app.Activity
import android.widget.TextView
import android.os.Bundle
import com.brother.ptouch.sdk.printdemo.R
import android.content.Intent
import android.view.View

class Activity_ScrollingText : Activity() {
    private var textView: TextView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_scrolling_text)
        val intent = intent
        val message = intent.getStringExtra(Intent.EXTRA_TEXT)
        if (message != null) {
            textView = findViewById<View>(R.id.textView) as TextView
            textView!!.text = message
        }
    }
}