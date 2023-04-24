import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/teacherlist.dart';
import 'package:teachmewell/faculty.dart';
import 'firebase_options.dart';
import 'package:teachmewell/sigarra/scraper.dart';
import 'dart:io' as io;


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeachMeWell',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Faculties(title: 'TeachMeWell'),
    );
  }
}

class Faculties extends StatelessWidget {
  const Faculties({super.key, required this.title});

  //Main page at the moment
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
          )),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Faculdades'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Pesquisar um docente',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllTeachersPage()
                ));
              },
            ),
          ],
          ),
        body: const LisTileExample(),
      ),
    );
  }
}


class LisTileExample extends StatefulWidget {
  const LisTileExample({super.key});

  @override
  State<LisTileExample> createState() => _LisTileExampleState();
}

class _LisTileExampleState extends State<LisTileExample>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('faculdade').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder:  (context, index) =>
                build_List_Item(context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        }
    );
  }

  Widget build_List_Item(BuildContext context, DocumentSnapshot document) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Hero(
          tag: 'Faculdade',
          // Wrap the ListTile in a Material widget so the ListTile has someplace
          // to draw the animated colors during the hero transition.
          child: Material(
            child: ListTile(
              title: Text(document["sigla"]),
              subtitle: Text(document["nome"]),
              tileColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => //ProfessorsFeup(document, document["sigla"]),
                    Faculty(document),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ProfessorsFeup extends StatelessWidget {
  final DocumentSnapshot document;
  final String faculdade;

  ProfessorsFeup(this.document, this.faculdade);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Professores"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('professor').where('faculdade', isEqualTo: faculdade).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('A carregar...');
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                itemBuilder:  (context, index) =>
                    _buildListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
              );
            }
        )
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {

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
                foregroundImage: NetworkImage('https://sigarra.up.pt/${document['faculdade'].toString().toLowerCase()}/pt/FOTOGRAFIAS_SERVICE.foto?pct_cod=${document['codigo']}'),
                backgroundImage: const NetworkImage('https://www.der-windows-papst.de/wp-content/uploads/2019/03/Windows-Change-Default-Avatar-448x400.png'),
                radius: 30,
                onBackgroundImageError: (e, s) {
                  debugPrint('image issue, $e,$s');
                },
              ),
            ),
          ),
          Expanded(
              child: Text(
                document['nome'],
                style: const TextStyle(fontSize: 22.0, color: Colors.black),
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
          )
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetails(document),
          ),
        );
      }
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
