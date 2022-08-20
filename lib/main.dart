import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ICalendar iCalendar;

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles = [];
  String _sharedText = "initial";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
      Fluttertoast.showToast(msg: "getTextStream() value: $value");
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((value) async {
      if (value != null) {
        if (value.isNotEmpty) {
          try {
            // Uri string
            setState(() => _isLoading = true);

            debugPrint("valueMain: $value");

            File file = await toFile(value); // Converting uri to file

            final icsLines = await file.readAsLines();

            iCalendar = ICalendar.fromLines(icsLines);

            final te = VComponent.parse(await file.readAsString()) as VCalendar;

            final VEvent? event = te.event;
            if (event != null) {
              
              print("\n version: ${event.version}");
              print("\n version: ${event.start}");
              print("\n version: ${event.end}");
              print("\n version: ${event.duration}");
              print("\n organizer: ${event.organizer!.email}");
              print("\n version: ${event.attendees}");
              
            }

            print("hi aks: $te");

            setState(() => _isLoading = false);
          } on UnsupportedError catch (e) {
            debugPrint(e.message); // Unsupported error for uri not supported
          } on IOException catch (e) {
            print(e); // IOException for system error
          } catch (e) {
            print(e); // General exception
          }
        }
      }

      Fluttertoast.showToast(msg: "get Initial text() value: $value");
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading || iCalendar == null)
                const Center(child: CircularProgressIndicator())
              else
                _generateTextContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateTextContent() {
    const style = TextStyle(color: Colors.black);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'VERSION: ${iCalendar.version}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'PRODID: ${iCalendar.prodid}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'CALSCALE: ${iCalendar.calscale}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'METHOD: ${iCalendar.method}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              children: iCalendar.data
                  .map((e) => TextSpan(
                        children: e.keys
                            .map((f) => TextSpan(children: [
                                  TextSpan(
                                      text: '${f.toUpperCase()}: ',
                                      style: style.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: '${e[f]}\n')
                                ]))
                            .toList(),
                      ))
                  .toList()),
        ],
        style: style,
      ),
    );
  }
}
