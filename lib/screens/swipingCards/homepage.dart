import 'package:flutter/material.dart';
import 'BackgroudCurveWidget.dart';
import 'CardsStackWidget.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        BackgroudCurveWidget(),
        CardsStackWidget(),
      ],
    );
  }
}
