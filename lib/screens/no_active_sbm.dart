import 'package:flutter/material.dart';
import 'package:gpi_sbm_app/widgets/custom_box.dart';
import 'package:gpi_sbm_app/widgets/custom_text.dart';

class AnketBulunamadi extends StatelessWidget {
  const AnketBulunamadi({Key? key}) : super(key: key);

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
                Color(0xFFF6A064),
                Color(0xFFF24223),
                Color(0xFFEA7A6C),
                Color(0xFF27823),
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
            text: "Stimmungsbarometer nicht aktiv!",
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
