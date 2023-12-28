import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

import '../models/add_hachlata_home_new_test.dart';

class FirestoreDataFetcher {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>> allData = {};

  Future<List<AddHachlataHomeNewTest>> fetchAllCollectionsData() async {
    DocumentSnapshot collectionsDoc = await firestore
        .collection('addHachlataHomeNew')
        .doc(globals.current_namesofuser)
        .get();
    print('all collection data ${collectionsDoc}');

    Map<String, dynamic> collectionsData =
        collectionsDoc.data() as Map<String, dynamic>;
    List<String> collectionNames = collectionsData.keys.toList();

    List<AddHachlataHomeNewTest> dataList = [];

    for (String collectionName in collectionNames) {
      QuerySnapshot documents =
          await firestore.collection(collectionName).get();

      List<AddHachlataHomeNewTest> collectionData = [];
      for (var document in documents.docs) {
        Map<String, dynamic> docData = document.data() as Map<String, dynamic>;

        AddHachlataHomeNewTest newData = AddHachlataHomeNewTest(
          uid: docData['uid'],
          name: docData['name'],
          date: docData['date'],
          hebrewdate: docData['hebrewdate'],
          color: docData['color'],
        );

        collectionData.add(newData);
        print('Document ID: ${document.id}, Data: ${document.data()}');
      }

      dataList.addAll(collectionData);
      print('Fetched data for collection: $collectionName');
    }

    print('All docs in all collections length = ${allData.length}');
    print('Document does not exist or is empty');
    print('current name of user for doc ${globals.current_namesofuser}');

    return dataList;
  }
}
