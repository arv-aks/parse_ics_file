import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ics_r/screens/home_page.dart';
import 'package:ics_r/screens/ics_event_detail.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

const String routeIcsEventDetail = "ics_event_detail";
const String routeHomePage = "home_page";

//for routing
class InitialData {
  final String sharedText;
  final String routeName;

  InitialData(this.sharedText, this.routeName);
}

//set up route
Future<InitialData> init() async {
  String sharedText = "";
  String routeName = routeHomePage;

  String? sharedValue = await ReceiveSharingIntent.getInitialText();
  if (sharedValue != null) {
    sharedText = sharedValue;
    routeName = routeIcsEventDetail;
  }

  return InitialData(sharedText, routeName);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialData initData = await init();
  runApp(MyApp(initData: initData));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initData});

  final InitialData initData;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    //This shared intent work when application is in memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _navKey.currentState!.pushNamed(
        routeIcsEventDetail,
        arguments: value,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case routeHomePage:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case routeIcsEventDetail:
            {
              if (settings.arguments != null) {
                final args = settings.arguments as String;
                return MaterialPageRoute(
                    builder: (_) => IcsEventDetail(
                          sharedText: args,
                        ));
              } else {
                return MaterialPageRoute(
                    builder: (_) => IcsEventDetail(
                          sharedText: widget.initData.sharedText,
                        ));
              }
            }
        }
      },
      initialRoute: widget.initData.routeName,
    );
  }
}
