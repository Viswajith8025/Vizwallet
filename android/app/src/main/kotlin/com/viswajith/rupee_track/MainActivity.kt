package com.viswajith.rupee_track

import android.os.Bundle
import com.viswajith.rupee_track.widget.WidgetRefreshScheduler
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WidgetRefreshScheduler.schedule(applicationContext)
    }
}
