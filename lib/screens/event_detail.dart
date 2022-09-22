import 'package:flutter/material.dart';
import 'package:ics_r/model/ics_model.dart';
import 'package:ics_r/screens/single_event_detail.dart';

class EventDetailWidget extends StatelessWidget {
  const EventDetailWidget({Key? key, required this.icsData}) : super(key: key);

  final IcsData icsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(icsData.summary),
        centerTitle: true,
      ),
      body: SingleEventDetail(icsData: icsData)
    );
  }
}
