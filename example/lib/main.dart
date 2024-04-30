import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffigen_safer_ffi_demo/ffigen_safer_ffi_demo.dart'
    as ffigen_safer_ffi_demo;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int sumResult;
  late Future<int> sumAsyncResult;

  String testString = "testString";
  String testBytes = "testBytes";

  @override
  void initState() {
    super.initState();
    sumResult = ffigen_safer_ffi_demo.sum(1, 2);
    sumAsyncResult = ffigen_safer_ffi_demo.sumAsync(3, 4);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'sum(1, 2) = $sumResult',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                FilledButton(
                    onPressed: () {
                      testString = ffigen_safer_ffi_demo
                              .testString("${DateTime.now()}") ??
                          testString;
                      setState(() {});
                    },
                    child: Text(testString)),
                FilledButton(
                    onPressed: () {
                      final str = "${DateTime.now()}" * Random().nextInt(10);
                      testBytes =
                          "bytes:${ffigen_safer_ffi_demo.testBytes(utf8.encode(str))}";
                      setState(() {});
                    },
                    child: Text(testBytes)),
                FilledButton(
                    onPressed: () {
                      final watch = Stopwatch()..start();
                      final watchGenerate = Stopwatch()..start();
                      final length = 1024 * 1024 * 300 + Random().nextInt(256);
                      //List.generate is slow
                      /*final bytes = List<int>.generate(length, (index) => Random().nextInt(256));*/
                      final bytes = Uint8List(length);
                      watchGenerate.stop();
                      print("generate: ${watchGenerate.elapsedMilliseconds}ms");
                      testBytes =
                          "bytes:${ffigen_safer_ffi_demo.testBytes(bytes /*Uint8List.fromList(bytes)*/)}";
                      watch.stop();
                      print("testBytes-big: ${watch.elapsedMilliseconds}ms");
                      setState(() {});
                    },
                    child: const Text("testBytes-big")),
                spacerSmall,
                FutureBuilder<int>(
                  future: sumAsyncResult,
                  builder: (BuildContext context, AsyncSnapshot<int> value) {
                    final displayValue =
                        (value.hasData) ? value.data : 'loading';
                    return Text(
                      'await sumAsync(3, 4) = $displayValue',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
