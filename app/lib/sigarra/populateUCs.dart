import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';
import'scraper.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> courses = FirebaseFirestore.instance.collection('curso').snapshots();

Future<void> populateUCs() async {
  // Set<String> faculties = {};
  await for (final s in courses) {
    for(int i = 0; i < s.docs.length; i++) {
      final course = s.docs[i];
      // if(faculties.contains(course['faculdade'])){
      //   print("Ja existe: " + course['faculdade']);
      //   continue;
      // }
      // faculties.add(course['faculdade']);
      Stream<UC> stream = await getCourseUCsIDsStream(course['faculdade'], course['id'], 2022);
      await for (final uc in stream) {
        if (uc.nome != "") {
          final newDocument = FirebaseFirestore.instance.collection('uc').doc(
              uc.faculdade.toUpperCase() + uc.codigo);
          final json = {
            'nome': uc.nome,
            'codigo': uc.codigo,
            'faculdade': uc.faculdade.toUpperCase(),
            'courseId': course['id']
          };
          print(json);

          await newDocument.set(json);
          // break;
        }
      }
    }
  }
}

Future<void> main() async {
  print("Starting...");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await populateUCs();
  print("Done!");
}
