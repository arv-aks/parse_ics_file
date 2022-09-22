import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:ics_r/model/ics_model.dart';
import 'package:ics_r/screens/event_detail.dart';
import 'package:ics_r/screens/single_event_detail.dart';
import 'package:intl/intl.dart';
import 'package:uri_to_file/uri_to_file.dart';

class IcsEventDetail extends StatefulWidget {
  IcsEventDetail({Key? key, this.sharedText}) : super(key: key);

  String? sharedText;

  @override
  State<IcsEventDetail> createState() => _IcsEventDetailState();
}

class _IcsEventDetailState extends State<IcsEventDetail> {
  final styleBold = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final styleNormal = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Event Detail"),
          ),
          body: FutureBuilder(
            future: getEvent(widget.sharedText),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final List<IcsData> dataList = snapshot.data as List<IcsData>;
                return dataList.length > 1
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 3,
                            ),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            minVerticalPadding: 5,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EventDetailWidget(
                                    icsData: dataList[index]);
                              }));
                            },
                            leading: dataList[index].dtstart.dt != null
                                ? CircleAvatar(
                                    maxRadius: 25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${DateTime.parse(dataList[index].dtstart.dt!).day}"
                                                .toUpperCase()),
                                        Text(
                                          DateFormat("MMM").format(
                                              DateTime.parse(
                                                  dataList[index].dtstart.dt!)),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                            title: Text(
                              dataList[index].summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: dataList[index].description == null
                                ? null
                                : Text(
                                    dataList[index].description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          );
                        })
                    : SingleEventDetail(icsData: dataList[0]);
              }
              return const CircularProgressIndicator();
            }),
          )),
    );
  }

  Future<List?> getEvent(String? path) async {
    if (path != null) {
      List<IcsData> icsList = [];
      try {
        if (Uri.parse(path).isAbsolute) {
          File file = await toFile(path); // Converting uri to file

          final decodedData = jsonDecode(
              jsonEncode(ICalendar.fromLines(file.readAsLinesSync()).toJson()));

          final restData = decodedData["data"] as List;
          for (int i = 0; i < restData.length; i++) {
            if (restData[i]["type"] == "VEVENT") {
              final json = jsonEncode(restData[i]);
              icsList.add(IcsData.fromJson(jsonDecode(json)));
            }
          }
          return icsList;
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
}
