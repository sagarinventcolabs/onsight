import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  MyWebView({Key? key,}) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  var url = "";
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    url = Get.arguments;
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(sharePoint),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.

      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {

            },

            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },

          ),

          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack()
        ],
      )
    );
  }
}
