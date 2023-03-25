import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyModel {
  final String name;

  MyModel(this.name);

  factory MyModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MyModel(
      snapshot.get('rating'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();

  // ---------------------------------------

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    num acc = 0;
    // make a query to find all comments in the comment collection, and add its rating to acc
    FirebaseFirestore.instance.collection('teacher').doc(document.id).collection('comments').get().then((value) => {
      value.docs.forEach((element) {
        acc += element.get('rating');
      })
    });

    return ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text(
                document['name'],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              acc.toString(),
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("TeachMeWell"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teacher').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
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

}

class ProfileDetails extends StatelessWidget {
  final DocumentSnapshot document;

  ProfileDetails(this.document);

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
    final json = { 'description': description, 'rating': rating, 'teacher': int.parse(document.id) };

    // Write to Firebase
    await newDocument.set(json);
  }

  @override
  Widget build(BuildContext context) {
    final description = TextEditingController();
    final rating = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(document['name']),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network('https://sigarra.up.pt/feup/pt/FOTOGRAFIAS_SERVICE.foto?pct_cod=' + document.id),
              Text(document['name'], style: Theme.of(context).textTheme.headlineMedium,),
              Text(document['department'], style: Theme.of(context).textTheme.headlineSmall,),
              Container(
                height: 220,
                width: 400,
                child: listComments(context),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              Text('\n\nComment:'),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextFormField(
                controller: rating,
                decoration: InputDecoration(
                  labelText: 'Rating',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final d = description.text;
                  final r_temp = rating.text;
                  double r;

                  try {
                    r = double.parse(r_temp);
                    if(r >= 0 && r <= 5) {
                      addComment(d, r);
                      description.clear();
                      rating.clear();
                    }
                  } catch (e) {}
                },
                child : Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listComments(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('comments').where('teacher', isEqualTo: int.parse(document.id) ).snapshots(),
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

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
