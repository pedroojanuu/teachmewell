import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


List<String> listTest = ["Pedro Lima", "Joao Coelho", "Pedro Januario", "Joao Mota", "Pedro Landolt"];

void fakeMain() async {
  print("Start fakeMain");

  // documentsLoopFromFirestore();
  List<dynamic> res = await search("Ademar", "FEUP", 2);
  res.forEach((element) => print(element));

  print("End fakeMain");
}

Future<List<dynamic>> search(String source, String faculdade, int number_of_errors_per_word) async {
  List<dynamic> ret = [];

  var l_source = source.split(" ");
  var querySnapshot = await FirebaseFirestore.instance.collection("professor").where("faculdade", isEqualTo: faculdade).get();

  for(var element in querySnapshot.docs){
    String s = element.data()['nome'].toString();
    var l_element = s.split(" ");

    int i = 0, j = 0;
    while (j < l_source.length && i < l_element.length) {
      int m = minimumEditDistance(l_source[j], l_element[i]);
      if (m < number_of_errors_per_word) {
        j++;
      }
      i++;
      if (j == l_source.length) {
        ret.add(s);
        // print("Added: $s");
      }
    }
  }

  return ret;
}

// List<String> search(String source, String faculdade){
//   List<String> ret = [];
//
//   // FirebaseFirestore.instance.collection("professor").where("faculdade", isEqualTo: "FEUP").get().then(
//   //       (value) {
//   //     value.docs.forEach(
//   //           (result) {
//   //         print(result.data()['nome']);
//   //       },
//   //     );
//   //   },
//   // );
//
//   // FirebaseFirestore.instance.collection("professor").where("faculdade", isEqualTo: faculdade).get().then(
//   //       (value) {
//   //     value.docs.forEach(
//   //           (result) {
//   //             String s = result.data()['nome'].toString();
//   //             print(s);
//   //             int dif = s.length - source.length;
//   //             if(dif < 0) dif = -dif;
//   //             int m = minimumEditDistance(source, s);
//   //
//   //             if(m - dif <= 3){
//   //               ret.add(result);
//   //             }
//   //       },
//   //     );
//   //   },
//   // );
//
//   var l_source = source.split(" ");
//   dynamic v;
//   FirebaseFirestore.instance.collection("professor").where("faculdade", isEqualTo: "FEUP").get().then(
//         (value) {
//           for(var element in value.docs){
//             String s = element.data()['nome'].toString();
//             var l_element = s.split(" ");
//
//             int i = 0, j = 0;
//             while (j < l_source.length && i < l_element.length) {
//               int m = minimumEditDistance(l_source[j], l_element[i]);
//               // print("m: $m" + " j: " + l_source[j] + " i: " + l_element[i]);
//               if (m < 3) {
//                 j++;
//               }
//               i++;
//               if (j == l_source.length) {
//                 ret.add(s);
//                 print("Added: $s");
//               }
//             }
//           }
//         }
//   );
//
//   return ret;
// }

void documentsLoopFromFirestore() {
  FirebaseFirestore.instance.collection("professor").where("faculdade", isEqualTo: "FEUP").get().then(
        (value) {
      value.docs.forEach(
            (result) {
          print(result.data()['nome']);
        },
      );
    },
  );
}

int minimumEditDistance(String source, String target) {
  int n = source.length;
  int m = target.length;

  // print("Start minimumEditDistance");

  // Create the dp matrix
  List<List<int>> dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));

  // Initialize the base cases
  for (int i = 0; i <= n; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= m; j++) {
    dp[0][j] = j;
  }

  // Fill the dp matrix using dynamic programming
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
      if (source[i - 1] == target[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] = [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((a, b) => a < b ? a : b) + 1;
      }
    }
  }

  // print("End minimumEditDistance");

  return dp[n][m];
}