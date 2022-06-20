import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("GPI - Stimmungsbarometer"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 156, 226),
                Color.fromARGB(255, 9, 100, 236),
                Color.fromARGB(255, 6, 156, 226),
                Color.fromARGB(15, 35, 66, 240),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 0.6, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/logos/gpilogo.png',
              alignment: Alignment.topCenter,
            ),
          ),
          CustomText(
            text: "Danke für Deine Teilnahme.",
            fontSize: 20,
            textAlign: TextAlign.start,
            alignment: Alignment.topCenter,
            fontWeight: FontWeight.bold,
            textColor: Color.fromARGB(179, 255, 255, 255),
          ),
        ]),
      ),
    );
  }
}

class VetoPage extends StatelessWidget {
  const VetoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("GPI - Stimmungsbarometer"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 156, 226),
                Color.fromARGB(255, 9, 100, 236),
                Color.fromARGB(255, 6, 156, 226),
                Color.fromARGB(15, 35, 66, 240),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 0.6, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/logos/gpilogo.png',
              alignment: Alignment.topCenter,
            ),
          ),
          CustomText(
            text: "Du darfst nur einmal teilnehmen.",
            fontSize: 20,
            textAlign: TextAlign.start,
            alignment: Alignment.topCenter,
            fontWeight: FontWeight.bold,
            textColor: Color.fromARGB(179, 255, 255, 255),
          ),
        ]),
      ),
    );
  }
}
