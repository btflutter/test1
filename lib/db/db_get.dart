import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseGet {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getAktifAnket() async {
    String aktifAnket = '';
    await _firestore.collection('data').doc('aktif-anket').get().then((value) {
      aktifAnket = value.data()!['aktif-anket'];
    });
    return aktifAnket;
  }

  Future<List<Map<String, dynamic>>> getSorular(String aktifAnket) async {
    List<Map<String, dynamic>> sorular = [];
    await _firestore
        .collection('anketler')
        .doc(aktifAnket)
        .collection('sorular')
        .orderBy('soru tipi', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        sorular.add(element.data());
      }
    });
    return sorular;
  }

  Future<void> setCevaplar(
      String aktifAnket, Map<String, dynamic> cevaplar) async {
    String id = createID();
    cevaplar['tarih'] = DateTime.now();
    cevaplar['id'] = id;

    await _firestore
        .collection('anketler')
        .doc(aktifAnket)
        .collection('feedbacks')
        .doc(id)
        .set(cevaplar);
  }

  String createID() {
    return _firestore.collection('id').doc().id;
  }
}
