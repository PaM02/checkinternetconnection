import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hasInternet = false;
  late StreamSubscription subscription;
  late StreamSubscription internetsubscription;
  ConnectivityResult result = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });

    internetsubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    internetsubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message = "string";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;

                  result = await Connectivity().checkConnectivity();
                  // final color = hasInternet ? Colors.green : Colors.red;
                  final text = hasInternet ? 'internet' : 'no internet';

                  if (result == ConnectivityResult.mobile) {
                    message = "$text : mobile network";
                    Fluttertoast.showToast(
                      msg: message,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else if (result == ConnectivityResult.wifi) {
                    message = "$text : wifi network";
                    Fluttertoast.showToast(
                      msg: message,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    setState(() => message = "$text : no network");
                    message = "$text : no network";
                    Fluttertoast.showToast(
                      msg: message,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                },
                child: const Text("check")),
            hasInternet ? Text(message) : Container(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
