import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/sigarra/scraper.dart';
import 'package:teachmewell/main.dart';

// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   print("Starting...");
//   Stream<UC> stream = await getCourseUCsIDsStream("feup", 22803, 2022);
//   await for (final value in stream) {
//     print(value.nome);
//   }
//   print("Done!");
// }

//A palavra course tem o significado de curso no Reino Unido, Australia, Singapura e India. Ja nos EUA e no Canada tem o significado de unidade curricular.
class UC extends StatelessWidget {
  final DocumentSnapshot uc;

  UC(this.uc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(uc['nome']),
        ),
        body: StreamBuilder(
          stream: getUCsTeachersStream(uc['faculdade'], uc['id']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('A carregar...');
            return ListView.builder(
              // itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder: (context, index) => _buildListItem(context,(snapshot.data as QuerySnapshot).docs[index]),
            );
          },
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