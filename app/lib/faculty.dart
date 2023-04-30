import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/course.dart';

//A titulo de curioside, o termo course é utilizado com o significa de curso no Reino Unido, Australia, Singapura e India, enquanto que nos EUA e Canadá é utilizado com o significado de unidade curricular.
class Faculty extends StatelessWidget {
  final DocumentSnapshot faculty;

  Faculty(this.faculty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(faculty['sigla']),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('curso').where('faculdade', isEqualTo: faculty['sigla']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('A carregar...');
          return ListView.builder(
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) => _buildListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        },
      )
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    String grau = document['grau'].toString();
    String grau_abrev;
    if (grau == 'Licenciatura') grau_abrev = 'L';
    else if (grau == 'Mestrado Integrado') grau_abrev = 'MI';
    else if (grau == 'Mestrado') grau_abrev = 'M';
    else if (grau == 'Doutoramento') grau_abrev = 'D';
    else grau_abrev = 'O';
    return ListTile(
      title: Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: Text(
              grau_abrev,
              style: const TextStyle(fontSize: 32.0, color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              document['nome'],
              style: const TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Course(document),
        ),
      ),
    );
  }
}
