import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata.dart';
import 'package:tzivos_hashem_milwaukee/models/admins.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import '../models/hachlata_home_all.dart';
import '../models/add_hachlata_home.dart';
import '../models/category.dart';
import '../models/ueser.dart';

class DatabaseService {
  String Uid = '';
  DatabaseService({required this.Uid});
  //colection referance
  final categoryId = globals.hachlata_name_for_category_widget;

  final CollectionReference addCategory =
      FirebaseFirestore.instance.collection('addCategory');
  final CollectionReference addHachlataCategory =
      FirebaseFirestore.instance.collection('addHachlataCategory');
  final CollectionReference addHachlataHome =
      FirebaseFirestore.instance.collection('addHachlataHome');
  final CollectionReference doneHachlata =
      FirebaseFirestore.instance.collection('doneHachlata');
  final CollectionReference admins =
      FirebaseFirestore.instance.collection('admins');

  // addHachlata
  Future updateDoneHachlata(
    String uid,
    String name,
    String date,
    String color,
  ) async {
    return await addHachlataHome
        .doc(globals.done_hachlata_doc_name)
        .set({'uid': uid, 'name': name, 'date': date, 'color': color});
  }

  Future delteDoneHachlata() async {
    return await addHachlataHome.doc(globals.done_hachlata_doc_name).delete();
  }

  // snap shot for hachlatacategory
// hachlatacategory list from snapshot
  // List<DoneHachlata>? _donehachlataListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return DoneHachlata(
  //       name: doc['name'] as String,
  //       uid: doc['uid'] as String,
  //       date: doc['date'] as String,
  //     );
  //   }).toList();
  // }

  // getDoneHachlataStream stream
  // Stream<List<DoneHachlata>> get donehachlata {
  //   return doneHachlata.snapshots().map<List<DoneHachlata>>((querySnapshot) {
  //     final doneHachlata = _donehachlataListFromSnapshot(querySnapshot);
  //     return doneHachlata ?? [];
  //   });
  // }

// addHachlataHome
  Future updateHachlataHome(
    String uid,
    String name,
    String date,
    String color,
  ) async {
    return await addHachlataHome.doc(globals.hachlata_home_doc_name).set({
      'uid': uid,
      'name': name,
      'date': date,
      'color': color,
    });
  }

  Future delteHachlataHome() async {
    return await addHachlataHome.doc(globals.hachlata_home_doc_name).delete();
  }

  List<HachlataHomeAll>? _hachlataHomeAllListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HachlataHomeAll(
        uid: doc['uid'] as String,
        name: doc['name'] as String,
        date: doc['date'] as String,
        color: doc['color'] as String,
      );
    }).toList();
  }

  // getCatagory stream
  Stream<List<HachlataHomeAll>> get hachlatahomeall {
    return addHachlataHome.snapshots().map((querySnapshot) {
      final hachlataHome = _hachlataHomeAllListFromSnapshot(querySnapshot);
      return hachlataHome ??
          []; // Provide an empty list as the default value if it's null
    });
  }

  // snap shot for hachlatacategory
// hachlatacategory list from snapshot
  List<AddHachlataHome>? _hachlataHomeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AddHachlataHome(
        uid: doc['uid'] as String,
        name: doc['name'] as String,
        date: doc['date'] as String,
        color: doc['color'] as String,
      );
    }).toList();
  }

  // getCatagory stream
  Stream<List<AddHachlataHome>> get hachlatahome {
    return addHachlataHome.snapshots().map((querySnapshot) {
      final hachlataHome = _hachlataHomeListFromSnapshot(querySnapshot);
      return hachlataHome ??
          []; // Provide an empty list as the default value if it's null
    });
  }

// add hachlataCategory

  Future updateHachlataCategory(
      String name, String category, String discription, bool isClicked) async {
    return await addHachlataCategory.doc(globals.hachlata_name_for_widget).set({
      'name': name,
      'category': category,
      'discription': discription,
      'isClicked': isClicked
    });
  }

  Future delteHachlataCategory() async {
    return addHachlataCategory.doc(globals.hachlata_name_for_widget).delete();
  }

  // snap shot for hachlatacategory
// hachlatacategory list from snapshot
  List<AddHachlata>? _hachlataCategoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AddHachlata(
          name: doc['name'] as String,
          category: doc['category'] as String,
          discription: doc['discription'] as String,
          isClicked: doc['isClicked'] as bool);
    }).toList();
  }

  // getCatagory stream
  Stream<List<AddHachlata>> get hachlatacategory {
    return addHachlataCategory.snapshots().map((querySnapshot) {
      final hachlataCategory = _hachlataCategoryListFromSnapshot(querySnapshot);
      return hachlataCategory ??
          []; // Provide an empty list as the default value if it's null
    });
  }

// add category
  Future updateCategory(String name) async {
    return await addCategory.doc(categoryId).set({
      'name': name,
    });
  }

// snap shot for category
// category list from snapshot
  List<Category>? _categoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Category(name: doc['name'] as String);
    }).toList();
  }

  // getCatagory stream
  Stream<List<Category>> get catagory {
    return addCategory.snapshots().map((querySnapshot) {
      final categories = _categoryListFromSnapshot(querySnapshot);
      return categories ??
          []; // Provide an empty list as the default value if it's null
    });
  }

  // admins
  Future updateAdmin(String name, String uid) async {
    return await admins.doc().set({
      'name': name,
      'uid': uid,
    });
  }

  List<Admins>? _adminsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Admins(
        name: doc['name'] as String,
        uid: doc['uid'] as String,
      );
    }).toList();
  }

  // getCatagory stream
  Stream<List<Admins>> get admin {
    return admins.snapshots().map((querySnapshot) {
      final admins = _adminsListFromSnapshot(querySnapshot);
      return admins ??
          []; // Provide an empty list as the default value if it's null
    });
  }
}

//   final CollectionReference doneHachlata =
//       FirebaseFirestore.instance.collection('doneHachlata');

//   // addHachlata
//   Future updateDoneHachlata(
//     String name,
//     String uid,
//     String date,
//   ) async {
//     return await doneHachlata.doc(globals.done_hachlata_doc_name).set({
//       'name': name,
//       'uid': uid,
//       'date': date,
//     });
//   }

//   // snap shot for hachlatacategory
// // hachlatacategory list from snapshot
//   List<DoneHachlata>? _donehachlataListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return DoneHachlata(
//         name: doc['name'] as String,
//         uid: doc['uid'] as String,
//         date: doc['date'] as String,
//       );
//     }).toList();
//   }

//   // getDoneHachlataStream stream
//   Stream<List<DoneHachlata>> get donehachlata {
//     return doneHachlata.snapshots().map<List<DoneHachlata>>((querySnapshot) {
//       final doneHachlata = _donehachlataListFromSnapshot(querySnapshot);
//       return doneHachlata ?? [];
//     });
//   }
