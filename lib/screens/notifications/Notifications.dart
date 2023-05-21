import 'package:flutter/material.dart';

class Bands extends StatefulWidget {
  const Bands({Key? key}) : super(key: key);

  @override
  State<Bands> createState() => _BandsState();
}

class _BandsState extends State<Bands> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Bands")
    );
  }
}
