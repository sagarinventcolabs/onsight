package com.nthdegree.onsight

import android.content.Context
import android.media.AudioManager
import android.net.ConnectivityManager
import android.os.Build
import android.widget.Toast
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*
import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity : FlutterFragmentActivity(), MethodChannel.MethodCallHandler {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelID
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            onMethodCall(
                call,
                result
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("METHOD", "Method channel invoked  ")

        if (call.method == cameraShutterAction) {
            val value = call.argument<Boolean>(isCameraShutterOn)
            Log.d("METHOD", "Method channel invoked VALUE $value ")

            val handler = Handler(Looper.getMainLooper())
            val t = Timer()
            t.schedule(object : TimerTask() {
                override fun run() {
                    handler.post(Runnable {
                        val mgr: AudioManager =
                            getSystemService(Context.AUDIO_SERVICE) as AudioManager
                        with(mgr) {
                            if (!value!!)
                                setStreamVolume(AudioManager.STREAM_SYSTEM, 0, 0)
                            else
                                setStreamVolume(
                                    AudioManager.STREAM_SYSTEM,
                                    getStreamMaxVolume(AudioManager.STREAM_SYSTEM),
                                    AudioManager.FLAG_ALLOW_RINGER_MODES
                                )
                        }
                    })
                }
            }, 500)

        }else if (call.method == checkInternetSpeed){
           result.success(check_internet_speed());
        } else {
            val mgr: AudioManager =
                getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val volume = mgr.getStreamVolume(AudioManager.STREAM_SYSTEM)
            Log.d("METHOD", "Method channel invoked VOLUME $volume ")
            result.success(volume)
        }
    }


    fun check_internet_speed():Int{
        // Connectivity Manager
        val cm = applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        // Network Capabilities of Active Network
        val nc = cm.getNetworkCapabilities(cm.activeNetwork)
        var downSpeed = 5;
        if(nc!=null) {
            // DownSpeed in MBPS
            downSpeed = (nc?.linkDownstreamBandwidthKbps!!)

            // UpSpeed in MBPS
            val upSpeed = (nc.linkUpstreamBandwidthKbps)

            // Toast to Display DownSpeed and UpSpeed
            Toast.makeText(
                applicationContext,
                "Up Speed: $upSpeed Kbps \nDown Speed: $downSpeed Kbps",
                Toast.LENGTH_LONG
            ).show()
        }

        return downSpeed;
    }

    /**
     * defined the constant values
     */
    companion object {
        const val channelID = "com.nthdegree.onsight/service"
        const val cameraShutterAction = "cameraShutterAction"
        const val checkInternetSpeed = "checkInternetSpeed"
        const val isCameraShutterOn = "isCameraShutterON"
    }
}
