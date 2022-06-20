import 'package:gpi_sbm_app/db/db_get.dart';
import 'package:gpi_sbm_app/screens/last_page.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.aktifAnket}) : super(key: key);
  final String aktifAnket;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Map<String, dynamic>>> sorular;

  @override
  void initState() {
    super.initState();
    sorular = DataBaseGet().getSorular(widget.aktifAnket);
  }

  final PageController _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> cevaplar = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sorular,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  flex: 80,
                  child: Container(
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: snapshot.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (value) {
                          _currentPageNotifier.value = value;
                        },
                        itemBuilder: ((context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    child: _buildSoruMetni(snapshot, index)),
                                const SizedBox(height: 50),
                                Container(
                                    child: _buildCevaplar(snapshot, index)),
                              ],
                            ),
                          );
                        })),
                  ),
                ),
                Expanded(
                  flex: 15,
                  child:
                      Container(child: _buildButttons(snapshot.data!.length)),
                ),
                Expanded(
                  flex: 5,
                  child: Container(child: _buildPageIndicator(snapshot)),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSoruMetni(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    String soruMetni = snapshot.data![index]['soru metni'];
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
      child: Text(soruMetni,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black)),
    );
  }

  Widget _buildCevaplar(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    String soruTipi = snapshot.data![index]['soru tipi'] ?? ' ';
    if (soruTipi == 'çoktan seçmeli') {
      List tempSecenekler = (snapshot.data![index]['seçenekler'] as List);
      List<String> secenekler = [];

      for (var element in tempSecenekler) {
        secenekler.add(element.toString());
      }

      cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = '';

      GroupController controller = GroupController();
// Emoji Test

      return SimpleGroupedCheckbox(
        controller: controller,
        itemsTitle: secenekler,
        values: secenekler,
        groupStyle: GroupStyle(
            itemTitleStyle: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.normal, color: Colors.black)),
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      );
/*       return SimpleGroupedChips(
        controller: controller,
        itemTitle: secenekler,
        values: secenekler,
        chipGroupStyle: ChipGroupStyle(
          itemTitleStyle: TextStyle(
            fontSize: 80,
          ),
          backgroundColorItem: Color.fromARGB(255, 231, 8, 131),
          selectedColorItem: Color.fromARGB(255, 32, 165, 241),
          textColor: Colors.black,
          selectedTextColor: Colors.blue,
        ),
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      ); */

/*      return SimpleGroupedCheckbox(
        controller: controller,
        itemsTitle: secenekler,
        values: secenekler,
        groupStyle: GroupStyle(itemTitleStyle: const TextStyle(fontSize: 20)),
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      ); */
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: TextFormField(
            maxLines: 5,
            maxLength: 160,
            decoration: InputDecoration(
              hintText: '...',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) {
              cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
            },
            onSaved: (value) {
              cevaplar[snapshot.data![index]["soru metni"] ?? ' '] =
                  value.toString();
            },
          ),
        ),
      );
    }
  }

  Row _buildButttons(int pageCount) {
    String ileri = 'Weiter ->';
    String geri = '<- Zurück';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutQuart);
            },
            child: Text(geri)),
        ElevatedButton(
            onPressed: () async {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutQuart);

              if (_pageController.page! == pageCount.toDouble() - 1) {
                _formKey.currentState!.save();

                Map<String, dynamic> kullaniciCevaplari = {};
                kullaniciCevaplari['cevaplar'] = cevaplar;

                DataBaseGet()
                    .setCevaplar(widget.aktifAnket, kullaniciCevaplari);

                await SharedPreferences.getInstance().then((prefs) {
                  prefs.setString('userKey', DateTime.now().toString());
                  prefs.setString('sonAnket', widget.aktifAnket);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EndPage(),
                      ));
                });
              }
            },
            child: Text(ileri)),
      ],
    );
  }

  Padding _buildPageIndicator(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: StepPageIndicator(
          size: 25,
          currentPageNotifier: _currentPageNotifier,
          itemCount: snapshot.data!.length),
    );
  }
}



 /*  List<bool> check = [];
  final PageController _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  Map<String, dynamic> cevaplar = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sorular,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              // Addiert Background zu App
              /*    decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/error.png"),
                  fit: BoxFit.cover,
                ),
              ), */
              width: MediaQuery.of(context).size.width * 3.2,
              height: MediaQuery.of(context).size.width * 3.2,
              margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
              padding: EdgeInsets.fromLTRB(20, 0, 10, 20),

              // Background Farbe für die Screens
              /*       decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.blue.shade600,
                    Colors.blue.shade900
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ), */
              child: Column(
                children: [
                  Text(
                    '',
                    style: TextStyle(fontSize: 50),
                  ),
                  Expanded(
                    flex: 80,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: snapshot.data!.length,
                        onPageChanged: (value) {
                          _currentPageNotifier.value = value;
                        },
                        itemBuilder: ((context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildSoruMetni(snapshot, index),
                                const SizedBox(height: 50),
                                _buildCevaplar(snapshot, index),
                              ],
                            ),
                          );
                        })),
                  ),
                  Expanded(
                    flex: 15,
                    child: _buildButttons(snapshot.data!.length),
                  ),
                  Expanded(
                    flex: 5,
                    child: _buildPageIndicator(snapshot),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSoruMetni(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    String soruMetni = snapshot.data![index]['soru metni'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(100, 10, 10, 100),
      child: Text(soruMetni),
    );
  }

  Widget _buildCevaplar(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    String soruTipi = snapshot.data![index]['soru tipi'] ?? ' ';
    if (soruTipi == 'çoktan seçmeli') {
      List tempSecenekler = (snapshot.data![index]['seçenekler'] as List);
      List<String> secenekler = [];
      for (var element in tempSecenekler) {
        secenekler.add(element.toString());
      }

      GroupController controller = GroupController();
      return SimpleGroupedCheckbox(
        controller: controller,
        itemsTitle: secenekler,
        values: secenekler,
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      );
    }
    /* if (soruTipi == 'emoji') {
      List tempSecenekler = (snapshot.data![index]['seçenekler'] as List);
      List<String> secenekler = [];
      for (var element in tempSecenekler) {
        secenekler.add(element.toString());
      }

      GroupController controller = GroupController();
      return SimpleGroupedSwitch(
        controller: controller,
        itemsTitle: secenekler,
        values: secenekler,
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      );
    } */
    else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          maxLines: 5,
          maxLength: 160,
          decoration: InputDecoration(
            hintText: 'Ihre Meinung...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.teal),
            ),
          ),
          onChanged: (val) {
            cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
          },
        ),
      );
    }
  }

  Row _buildButttons(int pageCount) {
    String ileri = 'weiter ->';
    String geri = '<- zurück';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutQuart);
            },
            child: Text(geri)),
        ElevatedButton(
            onPressed: () {
              //print(cevaplar);
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutQuart);

              if (_pageController.page! == pageCount.toDouble() - 1) {
                Map<String, dynamic> kullaniciCevaplari = {};
                kullaniciCevaplari['cevaplar'] = cevaplar;

                DataBaseGet()
                    .setCevaplar(widget.aktifAnket, kullaniciCevaplari);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EndPage(),
                    ));
              }
            },
            child: Text(ileri)),
      ],
    );
  }

  Padding _buildPageIndicator(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: StepPageIndicator(
          size: 25,
          currentPageNotifier: _currentPageNotifier,
          itemCount: snapshot.data!.length),
    );
  }
}


return SimpleGroupedChips(
        controller: controller,
        itemTitle: secenekler,
        values: secenekler,
        chipGroupStyle: ChipGroupStyle(
            itemTitleStyle: TextStyle(
              fontSize: 14,
            ),
            backgroundColorItem: Colors.transparent,
            selectedColorItem: Colors.transparent,
            textColor: Colors.black,
            selectedTextColor: Colors.transparent),
        onItemSelected: (val) {
          cevaplar[snapshot.data![index]["soru metni"] ?? ' '] = val;
        },
      );

 */