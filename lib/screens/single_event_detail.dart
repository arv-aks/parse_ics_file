import 'package:flutter/material.dart';
import 'package:ics_r/model/ics_model.dart';

class SingleEventDetail extends StatelessWidget {
  const SingleEventDetail({Key? key, required this.icsData}) : super(key: key);

  final IcsData icsData;

  final styleBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  final styleNormal = const TextStyle(
    fontSize: 16,
  );

  Widget textSpanWidget(String heading, String data) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$heading :".toUpperCase(),
            style: styleBold,
          ),
          TextSpan(
            text: data,
            style: styleNormal,
          ),
        ],
      ),
    );
  }

  Widget attendeeWidget(List<Attendee> attendee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: attendee.map((e) => Text(e.name!)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textSpanWidget("title", icsData.summary),
            textSpanWidget("start", icsData.dtstart.dt ?? ""),
            textSpanWidget("end", icsData.dtend!.dt ?? ""),
            textSpanWidget("description", icsData.description ?? ""),
            textSpanWidget("attendees", ""),
            // attendeeWidget(icsData.attendee!),

            icsData.attendee != null && icsData.attendee!.isNotEmpty
                ? attendeeWidget(icsData.attendee!)
                : const SizedBox(),

            textSpanWidget("location", icsData.location ?? ''),

            icsData.organizer != null
                ? textSpanWidget("organizer", icsData.organizer!.name!)
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
