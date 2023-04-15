import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/teacherlist.dart';
import 'firebase_options.dart';


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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeachMeWell'),
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
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vind@ ao TeachMeWell!\n\nCarregue na lupa no canto superior direito para pesquisar um docente e ver os seus detalhes e avaliações.',
              style : TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
    );
  }
}

/*
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
*/
