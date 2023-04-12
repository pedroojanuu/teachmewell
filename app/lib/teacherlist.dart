import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AllTeachersPage extends StatefulWidget {
  @override
  _AllTeachersPageState createState() => _AllTeachersPageState();
}

class _AllTeachersPageState extends State<AllTeachersPage> {
  TextEditingController _textEditingController = TextEditingController();

  List<String> testListOnSearch = [];
  List<String> testList = ["Euskal Herria", "Portugal", "Deutschland", "Catalunya", "United States", "Australia", "Galiza", "Andorra", "Cuba", "Brasil", "Colombia", "Uruguay", "Chile", "Italia"];

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
                  testListOnSearch = testList
                      .where((element) => element.toLowerCase().contains(value.toLowerCase()))
                      .toList();
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
      body: testListOnSearch.isEmpty && _textEditingController!.text.isNotEmpty?
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
                  ]
              ),
          ) :
      ListView.builder(
          itemCount: _textEditingController!.text.isNotEmpty? testListOnSearch.length : testList.length,
          itemBuilder: (_, index) {
            return Row(
              children: [
                SizedBox(height: 50,),
                Text(
                  _textEditingController!.text.isNotEmpty?
                  testListOnSearch[index] : testList[index],
                  style: TextStyle(fontSize: 20),),
              ],
            );
          },
        )
    );
  }
}

/*
class AllTeachersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Docentes'),
      ),
      body: _buildListView(context),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('The list item #$index'),
            subtitle: Text('The subtitle'),
            leading: Icon(Icons.thumb_up),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherPage(index.toString())));
            },
          ),
        );
      },
    );
  }
}

class TeacherPage extends StatelessWidget {
  final String rowid;

  TeacherPage(this.rowid);

  final DocumentSnapshot document = newObject();

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
*/