import 'package:gpi_sbm_app/screens/no_active_sbm.dart';
import 'package:gpi_sbm_app/screens/last_page.dart';
import 'package:gpi_sbm_app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_get.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<String> _aktifAnket;

  String routePage = 'main';

  @override
  void initState() {
    super.initState();
    _aktifAnket = DataBaseGet().getAktifAnket();
    _aktifAnket.then((aktifAnket) {
      loadData(aktifAnket);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _aktifAnket,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '') {
              return const AnketBulunamadi();
            } else if (routePage == 'main') {
              return MainPage(aktifAnket: snapshot.data!);
            } else {
              return const VetoPage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void loadData(String anketAdi) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _userKey = _prefs.getString('userKey') ?? DateTime.now().toString();
      var _sonAnket = _prefs.getString('sonAnket') ?? ' ';

      if (_sonAnket == anketAdi) {
        DateTime userTime = DateTime.parse(_userKey);
        DateTime now = DateTime.now().add(const Duration(days: -1));

        if (userTime.isBefore(now)) {
          routePage = 'main';
        } else {
          routePage = 'veto';
        }
      } else {
        routePage = 'main';
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
