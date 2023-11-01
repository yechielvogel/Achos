import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

// class FirestoreDataFetcher {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   Map<String, Map<String, dynamic>> allData = {};

//   Future<void> fetchAllCollectionsData() async {
//     // Assuming 'documentWithCollections' contains the list of collections
//     DocumentSnapshot collectionsDoc = await firestore
//         .collection('addHachlataHomeNew')
//         .doc('Yechiel Vogel')
//         .get();
//     print('all collection data ${collectionsDoc}');

//     Map<String, dynamic> collectionsData =
//         collectionsDoc.data() as Map<String, dynamic>;
//     List<String> collectionNames = collectionsData.keys.toList();

//     for (String collectionName in collectionNames) {
//       QuerySnapshot documents =
//           await firestore.collection(collectionName).get();

//       Map<String, dynamic> collectionData = {};
//       for (var document in documents.docs) {
//         collectionData[document.id] = document.data();
//         print('Document ID: ${document.id}, Data: ${document.data()}');
//       }
//       allData[collectionName] = collectionData;
//       print('Fetched data for collection: $collectionName');
//     }
//     print('All docs in all collections length = ${allData.length}');

//     print('Document does not exist or is empty');
//     print('curent name of user for doc ${globals.current_namesofuser}');
//   }
// }
