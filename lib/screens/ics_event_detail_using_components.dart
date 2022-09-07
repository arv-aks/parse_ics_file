import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter/material.dart';

class IcsEventDetailUsingComponents extends StatelessWidget {
  const IcsEventDetailUsingComponents({Key? key, required this.data})
      : super(key: key);

  final VEvent data;

  final styleBold = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final styleNormal = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
        "DETAILS USING COMPONENTS OF EVENT",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
      Text.rich(TextSpan(text: 'Title: ', style: styleBold, children: [
        TextSpan(
          text: '${data.summary}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Description: ', style: styleBold, children: [
        TextSpan(
          text: '${data.description}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Start: ', style: styleBold, children: [
        TextSpan(
          text: '${data.start}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'End: ', style: styleBold, children: [
        TextSpan(
          text: '${data.end}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Created: ', style: styleBold, children: [
        TextSpan(
          text: '${data.created}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'RecurrenceRule: ', style: styleBold, children: [
        TextSpan(
          text: '${data.recurrenceRule}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Organiser: ', style: styleBold, children: [
        TextSpan(
          text: '${data.organizer}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Attendees: ', style: styleBold, children: [
        TextSpan(
          text: '${data.attendees}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Attachments: ', style: styleBold, children: [
        TextSpan(
          text: '${data.attachments}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Location: ', style: styleBold, children: [
        TextSpan(
          text: '${data.location}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Last modified: ', style: styleBold, children: [
        TextSpan(
          text: '${data.lastModified}',
          style: styleNormal,
        )
      ])),
      Text.rich(TextSpan(text: 'Status: ', style: styleBold, children: [
        TextSpan(
          text: '${data.status}',
          style: styleNormal,
        )
      ])),
    ]);
  }
}
