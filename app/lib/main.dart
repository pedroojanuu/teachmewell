import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/teacher.dart';
import 'firebase_options.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_native/flutter_rating_native.dart';

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
                    builder: (context) => ProfessorsFeup(document, document["sigla"]),
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

    final GlobalKey<FormState> _formKey = GlobalKey();
    final TextEditingController _controller = TextEditingController();
    final titulo = TextEditingController();
    final comentario = TextEditingController();

    double relacionamento = 0;
    double interesse = 0;
    double regras = 0;
    double disponibilidade = 0;
    double empenho = 0;
    double exigencia = 0;
    double conteudos = 0;
    double reflexao = 0;
    double ensino = 0;
    double media_single = 0;


    return Scaffold(
      appBar: AppBar(
        title: Text(document['nome']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
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
                    ),
                  ),
                ),
                Expanded(
                  child: Text(document['nome'], style: Theme.of(context).textTheme.headlineSmall,),
                  ),
              ],
            ),
            SizedBox(
              child: Text(document['faculdade'], style: Theme.of(context).textTheme.headlineSmall,),
            ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      scrollable: true,
                      content: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              child: Text('Bom Relacionamento com os Estudantes'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                relacionamento = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Capacidade de Estimular o Interesse'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                interesse = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Cumprimento das Regras de Avaliação'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                regras = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Disponibilidade'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                disponibilidade = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Empenho'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                empenho = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Exigência'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                exigencia = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Organização dos Conteúdos'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                conteudos = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Promoção da Reflexão'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                reflexao = rating;
                              },
                            ),
                            const SizedBox(
                              child: Text('Qualidade do Ensino'),
                            ),
                            RatingBar.builder(
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.orange),
                              onRatingUpdate: (rating) {
                                ensino = rating;
                              },
                            ),
                            TextFormField(
                              controller: titulo,
                              decoration: const InputDecoration(
                                labelText: 'Titulo',
                                  hintText: 'Escreva uma breve descrição',
                              ),
                              maxLength: 20,
                            ),
                            TextFormField(
                              controller: comentario,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Comentário',
                                filled: true,
                              ),
                              maxLines: 5,
                              maxLength: 500,
                              textInputAction: TextInputAction.done,
                              validator: (String? text) {
                                if(text == null || text.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                            onPressed: () async {
                              String aux = titulo.text.replaceAll(" ", "");
                              if(aux == "") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Erro de Input'),
                                    content: const Text('O Título não deve estar vazio'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  ),
                                );
                              }
                              else if(relacionamento == 0 || interesse == 0 || regras == 0 || disponibilidade == 0 || exigencia == 0 || conteudos == 0 || reflexao == 0 || ensino == 0){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Erro de Input'),
                                    content: const Text('Nenhum rating deve ficar por preencher!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  ),
                                );
                              }
                              else {
                                media_single = (relacionamento + interesse + regras + disponibilidade + empenho + exigencia + conteudos + reflexao + ensino) / 9;
                                addRating(relacionamento, interesse, regras, disponibilidade, empenho, exigencia, conteudos, reflexao, ensino, titulo.text, comentario.text, media_single);
                                Navigator.pop(context, 'Submit');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Comentário submetido'),
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
                            child: const Text('Submit')
                        )
                      ],
                    ),
                );
              },
              child: const Text('Avaliar'),
          ),
          Container(
              height: 220,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: listRatings(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> addRating(double relacionamento, double interesse, double regras, double disponibilidade, double empenho, double exigencia, double conteudos, double reflexao, double ensino, String titulo, String comentario, double media_single) async {
    final newDocument = FirebaseFirestore.instance.collection('avaliacao').doc();
    final json = {
      'bom relacionamento com os estudantes': relacionamento,
      'capacidade de estimular o interesse': interesse,
      'cumprimento das regras de avaliacao': regras,
      'disponibilidade': disponibilidade,
      'empenho': empenho,
      'exigencia': exigencia,
      'organizacao dos conteudos': conteudos,
      'promocao da reflexao': reflexao,
      'qualidade do ensino': ensino,
      'studentID': 202108677,
      'teacherID': document['codigo'].toString(),
      'titulo' : titulo,
      'comentario' : comentario,
      'media_single' : media_single,
    };
    // Write to Firebase
    await newDocument.set(json);
  }

  Widget listRatings(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('avaliacao').where('teacherID', isEqualTo : document['codigo'].toString()).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 55.0,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder:  (context, index) =>
                _buildListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        }
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document2) {

    return ListTile(
      title:
      Row(
        children: [
          Expanded(
            child: Text(
              document2['titulo'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                color: Color(0xffddddff),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                document2['media_single'].toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium,
              )
          )
        ],
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              scrollable: true,
              content: Column(
                children: [
                  const SizedBox(child: Text('Bom Relacionamento com os Estudantes'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['bom relacionamento com os estudantes'], size: 40),
                  ),
                  const SizedBox(child: Text('Capacidade de Estimular o Interesse'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['capacidade de estimular o interesse'], size: 40),
                  ),
                  const SizedBox(child: Text('Cumprimento das Regras de Avaliação'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['cumprimento das regras de avaliacao'], size: 40),
                  ),
                  const SizedBox(child: Text('Disponibilidade'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['disponibilidade'], size: 40),
                  ),
                  const SizedBox(child: Text('Empenho'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['empenho'], size: 40),
                  ),
                  const SizedBox(child: Text('Exigência'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['exigencia'], size: 40),
                  ),
                  const SizedBox(child: Text('Organização dos Conteúdos'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['organizacao dos conteudos'], size: 40),
                  ),
                  const SizedBox(child: Text('Promoção da Reflexão'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['promocao da reflexao'], size: 40),
                  ),
                  const SizedBox(child: Text('Qualidade do Ensino'),),
                  SizedBox(
                    child: FlutterRating (rating: document2['qualidade do ensino'], size: 40),
                  ),
                  Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Center(
                      child: Text(document2['titulo']),
                    )
                  ),
                  Container(
                      height: 220,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Text(document2['comentario']),
                        ),
                      )
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}
