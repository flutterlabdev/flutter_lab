import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'data_provider.dart';
import 'emits.dart';
import 'variables.dart';

io.Socket? socket;

/// FlutterLab wrapper
class FlutterLab extends StatefulWidget {
  const FlutterLab({
    Key? key,
    required this.child,
    this.enabled = true,
    this.url = "http://localhost",
    this.port = 3000,
  })  : assert(port > 0 && port <= 65535, 'Invalid port number'),
        super(key: key);
  final Widget child;
  final bool enabled;

  /// FlutterLab app connection url
  ///
  /// default url is 'http://localhost'
  ///
  /// Addresses like "http://192.168.1.200" can be used
  ///
  final String url;

  /// FlutterLab app url port
  ///
  /// default port: 3000
  final int port;
  @override
  State<FlutterLab> createState() => _FlutterLabState();
}

class _FlutterLabState extends State<FlutterLab> {
  late BuildContext tContext;

  bool inLocalHost = false;
  bool previouslyConnected = false;

  @override
  void initState() {
    if (widget.enabled) {
      if (validateUrl(widget.url)) {
        startConnection();
      }
    }
    super.initState();
  }

  void startConnection() {
    String url = widget.url;

    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }

    if (Platform.isAndroid && inLocalHost == false && url == "http://localhost") {
      url = "http://10.0.2.2";
    }

    Uri uri = Uri.parse(url);

    int port = uri.port;

    if (url.endsWith(port.toString()) == false) {
      port = widget.port;
    }

    var labUrl = Uri(scheme: uri.scheme, host: uri.host, port: port).toString();

    socket = io.io(
      labUrl,
      io.OptionBuilder().setTransports(['websocket', 'polling']).setReconnectionDelayMax(1).setReconnectionDelay(1).build(),
    );

    socket!.on('w_data', widgetData);
    socket!.on('clr', clearData);
    socket!.on('p_id', projectIdUpdate);

    socket!.onConnect((_) {
      connected = true;
      previouslyConnected = true;
      sendWidgetDataList();
    });
    socket!.onConnectError((e) {
      connected = false;
      if (previouslyConnected == false) {
        socketRestart();
      }
    });
    socket!.onDisconnect((e) {
      connected = false;
      tContext.read<DataProvider>().clearData();
    });
    socket!.connect();
  }

  void socketRestart() async {
    socket?.dispose();
    await Future.delayed(const Duration(milliseconds: 1500));

    String url = widget.url;
    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }

    if (Platform.isAndroid && url == "http://localhost") {
      inLocalHost ^= true;
    }

    startConnection();
  }

  void widgetData(data) {
    tContext.read<DataProvider>().dataUpdate(data);
  }

  void clearData(data) {
    tContext.read<DataProvider>().clearData();
  }

  void projectIdUpdate(data) {
    tContext.read<DataProvider>().projectIdRefresh(data);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: Builder(
        builder: (context) {
          tContext = context;
          return widget.child;
        },
      ),
    );
  }
}

bool validateUrl(String url) {
  if (url.endsWith("/")) {
    url = url.substring(0, url.length - 1);
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    assert(false, 'FlutterLab url parameter: Invalid URL format: $url');
    return false;
  }

  // Check for a valid protocol.
  if (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https')) {
    assert(false, 'FlutterLab url parameter: Invalid protocol: ${uri.scheme}');
    return false;
  }

  if (!uri.host.contains('.') && uri.host != "localhost") {
    assert(false, 'FlutterLab url parameter: Invalid URL format: $url');
    return false;
  }

  if (uri.path != '') {
    assert(false, 'FlutterLab url parameter: Should not contain path : ${uri.path}');
    return false;
  }

  return true;
}
