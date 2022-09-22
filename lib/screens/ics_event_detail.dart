import 'dart:convert';
import 'dart:io';

import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:ics_r/model/ics_model.dart';
import 'package:ics_r/screens/ics_event_detail_using_components.dart';
import 'package:uri_to_file/uri_to_file.dart';

class IcsEventDetail extends StatefulWidget {
  IcsEventDetail({Key? key, this.sharedText}) : super(key: key);

  String? sharedText;

  @override
  State<IcsEventDetail> createState() => _IcsEventDetailState();
}

class _IcsEventDetailState extends State<IcsEventDetail> {
  late Future<VEvent?> vEvent;

  ICalendar? _calendar;

  final styleBold = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final styleNormal = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  String test = "";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  List<IcsData> icsList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Event Detail"),
            actions: [
              IconButton(
                  onPressed: () async {
                    _calendar = await getEvent(widget.sharedText);
                    final data = jsonDecode(jsonEncode(_calendar!.toJson()));

                    final restData = data["data"] as List;

                    for (int i = 0; i < restData.length; i++) {
                      if (restData[i]["type"] == "VEVENT") {
                        // debugPrint("----- ret data : ${restData[i]}------- ");
                        final jss = jsonEncode(restData[i]);
                        icsList.add(IcsData.fromJson(jsonDecode(jss)));
                      }
                    }
                    debugPrint("icslenght: ${icsList.length}");

                    Clipboard.setData(ClipboardData(text: jsonEncode(_calendar!.toJson())));
                  },
                  icon: const Icon(Icons.headphones)),
            ],
          ),
          body: Column(children: [
            isLoading || _calendar == null || icsList.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                        itemCount: icsList.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                icsList[index].summary,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Time:   ${icsList[index].dtstart.dt!}",
                                style: TextStyle(fontWeight: FontWeight.w200),
                              ),
                              Divider(
                                height: 2,
                              ),
                            ],
                          );
                        }),
                  )
            // RichText(
            //     text: TextSpan(
            //         children: _calendar!.data
            //             .map((e) => TextSpan(
            //                   children: e.keys
            //                       .map((f) => TextSpan(children: [
            //                             TextSpan(
            //                                 text: '${f.toUpperCase()}: ',
            //                                 style: styleNormal.copyWith(
            //                                   color: Colors.black,
            //                                     fontWeight:
            //                                         FontWeight.bold)),
            //                             TextSpan(text: '${e[f]}\n', style: TextStyle(color: Colors.black))
            //                           ]))
            //                       .toList(),
            //                 ))
            //             .toList()),
          ])),
    );
  }

  Future<ICalendar?> getEvent(String? path) async {
    print("path: $path");

    setState(() {
      isLoading = true;
    });

    if (path != null) {
      try {
        if (Uri.parse(path).isAbsolute) {
          File file = await toFile(path); // Converting uri to file

          //  debugPrint("\n data: ${iCalendar.data}", wrapWidth: 1024);
          //  debugPrint("\n head data:; ${iCalendar.headData}", wrapWidth: 1024);

          setState(() {
            _calendar = ICalendar.fromLines(file.readAsLinesSync());
            isLoading = false;
          });

          return _calendar;
        }
        return null;
      } catch (e) {
        debugPrint("error: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  // Future<VEvent?> getEvent(String? path) async {
  //   print("path: $path");

  //   if (path != null) {
  //     try {
  //       if (Uri.parse(path).isAbsolute) {
  //         File file = await toFile(path); // Converting uri to file

  //         final icsLines = await file.readAsLines();
  //         final iCalendar = ICalendar.fromLines(icsLines);

  //         //  debugPrint("\n data: ${iCalendar.data}", wrapWidth: 1024);
  //         //  debugPrint("\n head data:; ${iCalendar.headData}", wrapWidth: 1024);

  //         final icsObj = ICalendar.fromLines(file.readAsLinesSync());
  //         debugPrint(jsonEncode(icsObj.toJson()), wrapWidth: 1024);

  //         final VCalendar vCalendar =
  //             VComponent.parse(await file.readAsString()) as VCalendar;

  //         return vCalendar.event;
  //       }
  //     } catch (e) {
  //       debugPrint("error: $e");
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }

}

class Mevent {
  final String type;
  String? description;
  final String summary;
  final Map<String, String> dtStart;
  Map<String, String>? dtEnd;
  String? location;

  Mevent(this.type, this.summary, this.dtStart);
}
