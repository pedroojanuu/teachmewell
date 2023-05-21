import 'package:flutter_test/flutter_test.dart';
import 'package:teachmewell/sigarra/scraper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teachmewell/firebase_options.dart';
import 'package:teachmewell/main.dart';
import 'package:teachmewell/teacher.dart';


void main() {
  test('Testing getUCTeachersIDs', () async {
    List<int> teachers = await getUCTeachersIDs("FEUP", 501682);
    Set<int> teachersSet = teachers.toSet();

    Set<int> expectedTeachers = {201100, 202091, 235739};

    expect(teachersSet, expectedTeachers);
  });

  test('Testing getUCTeachers', () async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // runApp(const MyApp());
    //
    // List<dynamic> teachers = await getUCTeachers("FEUP", 501682);
    //
    // Set<int> expectedTeachers = {201100, 202091, 235739};
    //
    // for(var teacher in teachers){
    //   expect(expectedTeachers.contains(teacher['id']), true);
    // }
  });

  test('Testing search 1', () async {
    List<TeacherDetails> teachers = [
      new TeacherDetails("10", "Nome1", "nome1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2", "nome2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    List<TeacherDetails> searchResult = search(teachers, "Nome", 2);

    List<TeacherDetails> expectedTeachers = [
      new TeacherDetails("10", "Nome1", "nome1", "FEUP", 123),
      new TeacherDetails("30", "Nome2", "nome2", "FEUP", 125),
    ];

    for(int i = 0; i < searchResult.length; i++){
      expect(equals(searchResult[i], expectedTeachers[i]), true);
    }

  });

  test('Testing search 2', () async {
    List<TeacherDetails> teachers = [
      new TeacherDetails("10", "Nome1", "nome1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2", "nome2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    List<TeacherDetails> searchResult = search(teachers, "Apelido", 2);

    List<TeacherDetails> expectedTeachers = [
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    for(int i = 0; i < searchResult.length; i++){
      expect(equals(searchResult[i], expectedTeachers[i]), true);
    }

  });

  test('Testing search 3', () async {
    List<TeacherDetails> teachers = [
      new TeacherDetails("10", "Nome1 Apelido1", "nome1 apelido1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2 Apelido2", "nome2 apelido2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
      new TeacherDetails("50", "Nome3", "nome3", "FEUP", 127),
    ];

    List<TeacherDetails> searchResult = search(teachers, "Apelido", 2);

    List<TeacherDetails> expectedTeachers = [
      new TeacherDetails("10", "Nome1 Apelido1", "nome1 apelido1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2 Apelido2", "nome2 apelido2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    for(int i = 0; i < searchResult.length; i++){
      expect(equals(searchResult[i], expectedTeachers[i]), true);
    }

  });

  test('Testing search 4', () async {
    List<TeacherDetails> teachers = [
      new TeacherDetails("10", "Nome1", "nome1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2", "nome2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    List<TeacherDetails> searchResult = search(teachers, "Lala", 20);

    List<TeacherDetails> expectedTeachers = [
      new TeacherDetails("10", "Nome1", "nome1", "FEUP", 123),
      new TeacherDetails("20", "Apelido1", "apelido1", "FEUP", 124),
      new TeacherDetails("30", "Nome2", "nome2", "FEUP", 125),
      new TeacherDetails("40", "Apelido2", "apelido2", "FEUP", 126),
    ];

    for(int i = 0; i < searchResult.length; i++){
      expect(equals(searchResult[i], expectedTeachers[i]), true);
    }

  });
}

bool equals(TeacherDetails t1, TeacherDetails t2){
  return t1.rowid == t2.rowid && t1.name == t2.name && t1.name_simpl == t2.name_simpl && t1.faculty == t2.faculty && t1.code == t2.code;
}