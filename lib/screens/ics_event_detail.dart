import 'dart:io';

import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter/material.dart';
import 'package:uri_to_file/uri_to_file.dart';

class IcsEventDetail extends StatefulWidget {
  IcsEventDetail({Key? key, this.sharedText}) : super(key: key);

  String? sharedText;

  @override
  State<IcsEventDetail> createState() => _IcsEventDetailState();
}

class _IcsEventDetailState extends State<IcsEventDetail> {
  late Future<VEvent?> vEvent;

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
        appBar: AppBar(title: const Text("Event Detail")),
        body: FutureBuilder(
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: Text(
                    'unable to parse ics file',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data as VEvent;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "COMPLETE DETAILS OF EVENT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          '$data',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Divider(
                          height: 8,
                          color: Colors.blue,
                        ),
                        const Text(
                          "DETAILS USING COMPONENTS OF EVENT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text.rich(TextSpan(
                            text: 'Title: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.summary}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Description: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.description}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Start: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.start}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'End: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.end}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Created: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.created}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'RecurrenceRule: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.recurrenceRule}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Organiser: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.organizer}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Attendees: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.attendees}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Attachments: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.attachments}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Location: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.location}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Last modified: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.lastModified}',
                                style: styleNormal,
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'Status: ',
                            style: styleBold,
                            children: [
                              TextSpan(
                                text: '${data.status}',
                                style: styleNormal,
                              )
                            ])),
                      ],
                    ),
                  ),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          future: getEvent(widget.sharedText),
        ),
      ),
    );
  }

  Future<VEvent?> getEvent(String? path) async {
    if (path != null) {
      try {
        if (Uri.parse(path).isAbsolute) {
          File file = await toFile(path); // Converting uri to file

          final VCalendar vCalendar =
              VComponent.parse(await file.readAsString()) as VCalendar;

          return vCalendar.event;
        }
      } catch (e) {
        debugPrint("error: $e");
        return null;
      }
    } else {
      return null;
    }
  }
}
