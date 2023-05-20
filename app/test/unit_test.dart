import 'package:flutter_test/flutter_test.dart';
import 'package:teachmewell/sigarra/scraper.dart';

void main() {
  test('Testins test', () async {
    List<int> teachers = await getUCTeachersIDs("FEUP", 501682);
    Set<int> teachersSet = teachers.toSet();

    Set<int> expectedTeachers = {201100, 202091, 235739};

    expect(teachersSet, expectedTeachers);
  });
}