import 'package:flutter_test/flutter_test.dart';
import 'package:teachmewell/sigarra/scraper.dart';

void main() {
  test('Testins test', () async {
    List<int> teachers = await getUCTeachersIDs("FEUP", 501682);
    Set<int> teachersSet = teachers.toSet();

    Set<int> expectedTeachers = {201100, 202091, 235739};

    expect(teachersSet, expectedTeachers);
  });

  test("FEUP_L.EIC UCs' IDs", () async {
    Set<int> expected_FEUP_LEIC = {
      501662, 501663, 501665, 501666, 501664, 501667, 501669, 501670, 501668,
      501672, 501671, 501673, 501674, 501675, 501677, 501676, 501680, 501678,
      501679, 501682, 501681, 501684, 501685, 501687, 501683, 501686, 501690,
      501688, 501689, 501692, 501691, 502284, 502227, 502236, 502290, 502285,
      502291, 502294, 502264, 502289};

    List<int> FEUP_LEIC = await getCourseUCsIDs('FEUP', 22841, 2022);
    Set<int> received_FEUP_LEIC = FEUP_LEIC.toSet();

    expect(received_FEUP_LEIC, expected_FEUP_LEIC);
  });

  test("FLUP_SOCI UCs' IDs", () async {
    Set<int> expected_FLUP_SOCI = {
      496882, 496884, 496885, 496883, 496886, 496888, 496889, 496887, 496890,
      496891, 496895, 496894, 496893, 496892, 496896, 496899, 496897, 496900,
      496898, 496901, 496902, 496906, 496903, 496908, 496907, 496911, 496904,
      496905, 496910, 496909, 496912};

    List<int> FLUP_SOCI = await getCourseUCsIDs('FLUP', 452, 2022);
    Set<int> received_FLUP_SOCI = FLUP_SOCI.toSet();

    expect(received_FLUP_SOCI, expected_FLUP_SOCI);
  });
}
