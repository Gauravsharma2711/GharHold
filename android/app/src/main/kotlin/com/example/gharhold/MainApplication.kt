package com.example.gharhold

import io.flutter.app.FlutterApplication
import sh.measure.android.Measure
import sh.measure.android.config.MeasureConfig

class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Measure.init(this, MeasureConfig())
    }
}
