import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'sigarra/scraper.dart';

class TeacherDetails {
  final String rowid;
  final String name;
  final String faculty;
  final int code;

  TeacherDetails(this.rowid, this.name, this.faculty, this.code);
}

class AllTeachersPage extends StatefulWidget {
  @override
  _AllTeachersPageState createState() {
    return new _AllTeachersPageState();
  }
}

Future<List<TeacherDetails>> getTeachersDetails() async {
  List<TeacherDetails> l = [];
  var querySnapshot = await FirebaseFirestore.instance.collection("professor").get();

  for (var element in querySnapshot.docs) {
    String rowid = element.id.toString();
    String name = element.data()['nome'].toString();
    String faculty = element.data()['faculdade'].toString();
    int code = int.parse(element.data()['codigo'].toString());
    l.add(TeacherDetails(rowid, name, faculty, code));
  }

  return l;
}

class _AllTeachersPageState extends State<AllTeachersPage> {
  TextEditingController _textEditingController = TextEditingController();

  List<TeacherDetails> teacherDetailsListOnSearch = [];
  List<TeacherDetails> teacherDetailsList = [];

  _AllTeachersPageState() {
    getTeachersDetails().then((val) => setState(() {
      teacherDetailsList = val;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  teacherDetailsListOnSearch = search(teacherDetailsList, _textEditingController.text, 2);
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Pequisar...'),
          )
        ),
      ),
      body: teacherDetailsList.isEmpty?
          Center(
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A carregar...',
                    style : TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          )
          : teacherDetailsListOnSearch.isEmpty && _textEditingController!.text.isNotEmpty?
          Center (
            child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sem resultados',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
              ),
          ) :
        ListView.builder(
            itemCount: _textEditingController!.text.isNotEmpty? teacherDetailsListOnSearch.length : teacherDetailsList.length,
            itemBuilder: (_, index) {
              TeacherDetails teacher = _textEditingController!.text.isNotEmpty? teacherDetailsListOnSearch[index] : teacherDetailsList[index];

              return ListTile(
                  title: Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 33,
                          child: CircleAvatar(
                            foregroundImage: NetworkImage('https://sigarra.up.pt/${teacher.faculty.toLowerCase()}/pt/FOTOGRAFIAS_SERVICE.foto?pct_cod=${teacher.code}'),
                            backgroundImage: const NetworkImage('https://www.der-windows-papst.de/wp-content/uploads/2019/03/Windows-Change-Default-Avatar-448x400.png'),
                            radius: 30,
                            onBackgroundImageError: (e, s) {
                              debugPrint('image issue, $e,$s');
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        //child: Text(teacher.name, style: const TextStyle(fontSize: 22.0, color: Colors.black),),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                teacher.name,
                                style: const TextStyle(fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(teacher.faculty),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffddddff),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '0',
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                      ),
                    ],
                  ),
                  onTap: () async {
                    final CollectionReference colRef = FirebaseFirestore.instance.collection('professor');

                    final DocumentReference docRef = colRef.doc(teacher.rowid);

                    final DocumentSnapshot documentSnapshot = await docRef.get();

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileDetails(documentSnapshot)
                    ));
                  }
              );
              /*return Card(
                child: ListTile(
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    _textEditingController!.text.isNotEmpty? nameListOnSearch[index].a : nameList[index].a,
                    style: TextStyle(fontSize: 20,),
                  ),
                  subtitle: Text(
                    _textEditingController!.text.isNotEmpty? nameListOnSearch[index].b : nameList[index].b,
                    style: TextStyle(fontSize: 13,),
                  ),
                  onTap: () async {
                    final CollectionReference colRef = FirebaseFirestore.instance.collection('professor');

                    final DocumentReference docRef = colRef.doc(_textEditingController!.text.isNotEmpty? nameListOnSearch[index].c : nameList[index].c);

                    final DocumentSnapshot documentSnapshot = await docRef.get();

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileDetails(documentSnapshot)
                    ));
                  },
                ),
              );*/
            },
          )
    );
  }
}

List<TeacherDetails> search(List<TeacherDetails> names, String source, int number_of_errors_per_word) {
  List<TeacherDetails> ret = [];

  var l_source = source.split(" ");

  for(var element in names){
    String s = element.name;
    var l_element = s.split(" ");

    int i = 0, j = 0;
    while (j < l_source.length && i < l_element.length) {
      int m = minimumEditDistance(l_source[j], l_element[i]);
      if (m < number_of_errors_per_word) {
        j++;
      }
      i++;
      if (j == l_source.length) {
        ret.add(element);
        //ret.add(Triplet<String,String, String>(s, element.b, element.c));
      }
    }
  }

  return ret;
}

int minimumEditDistance(String source, String target) {
  int n = source.length;
  int m = target.length;

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

  return dp[n][m];
}

class ProfileDetails extends StatelessWidget {
  final DocumentSnapshot document;

  ProfileDetails(this.document);

  @override
  Widget build(BuildContext context) {
    final description = TextEditingController();
    final rating = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(document['nome']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
                spacing: 10,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 55,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage('https://sigarra.up.pt/${document['faculdade'].toString().toLowerCase()}/pt/FOTOGRAFIAS_SERVICE.foto?pct_cod=${document['codigo']}'),
                        backgroundImage: const NetworkImage('https://www.der-windows-papst.de/wp-content/uploads/2019/03/Windows-Change-Default-Avatar-448x400.png'),
                        radius: 50,
                        onBackgroundImageError: (e, s) {
                          debugPrint('image issue, $e,$s');
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      child: Text(document['nome'], style: Theme.of(context).textTheme.headlineSmall,),
                    ),
                  ),
                  SizedBox(
                    child: Text(document['faculdade'], style: Theme.of(context).textTheme.headlineSmall,),
                  ),
                ]
            ),

            Container(
              height: 220,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: listComments(context),
            ),
            const Text('\n\nComment:'),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextFormField(
              controller: rating,
              decoration: const InputDecoration(
                labelText: 'Rating',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final d = description.text;
                final rTemp = rating.text;
                double r;

                try {
                  r = double.parse(rTemp);
                  if(r >= 0 && r <= 5) {
                    addComment(d, r);
                    description.clear();
                    rating.clear();
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Erro de Input'),
                        content: const Text('O valor do Rating deve ser um número entre 0 e 5!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Erro de Input'),
                      content: const Text('O valor do Rating deve ser um número entre 0 e 5!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              },
              child : const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document2) {

    return ListTile(
      title: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          DocumentReference documentReference = FirebaseFirestore.instance.collection('comments').doc(document2.id);
          documentReference.delete();
        },
        child:
        Row(
          children: [
            Expanded(
              child: Text(
                document2['description'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  color: Color(0xffddddff),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  document2['rating'].toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> addComment(String description, double rating) async {
    final newDocument = FirebaseFirestore.instance.collection('comments').doc();
    final json = { 'description': description, 'rating': rating, 'teacher': int.parse(document['codigo'].toString()) };

    // Write to Firebase
    await newDocument.set(json);
  }

  Widget listComments(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('comments').where('teacher', isEqualTo: int.parse(document['codigo'].toString())).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder:  (context, index) =>
                _buildListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        }
    );
  }
}

