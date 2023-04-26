import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/sigarra/scraper.dart';
import 'package:teachmewell/uc.dart';

//A palavra course tem o significado de curso no Reino Unido, Australia, Singapura e India. Ja nos EUA e no Canada tem o significado de unidade curricular.
class Course extends StatelessWidget {
  final DocumentSnapshot course;

  Course(this.course);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['sigla']),
      ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('uc').where('courseId', isEqualTo: course['id']).snapshots(),
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
    return ListTile(
      title: Expanded(
            child: Text(
              document['nome'],
              style: const TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UC(document),
        ),
      ),
    );
  }
}
