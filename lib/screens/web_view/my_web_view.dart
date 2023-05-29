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
  WebViewController _webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    if(Get.arguments!=null) {
      url = Get.arguments;
    }
    _webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
    ..loadRequest(Uri.parse(url.toString()));
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(sharePoint),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.

      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),

          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack()
        ],
      )
    );
  }
}
