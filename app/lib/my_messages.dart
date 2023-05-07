import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_native/flutter_rating_native.dart';

class MyMessages extends StatelessWidget{
  final int studentID;

  MyMessages(this.studentID);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
        title: Text('Profile'),
      backgroundColor: const Color(0xFF2574A8),
      actions: [],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('avaliacao').where('studentID', isEqualTo : studentID).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 55.0,
              itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder:  (context, index) =>
                  _buildListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
            );
          }
      )
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document2) {
    try{
      if(document2['titulo']==null || document2['media_single']==null)
          return Container();
    }catch(e){
      return Text("Error on document " + document2.id);
    }

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
                  child: FlutterRating (rating: document2['bom relacionamento com os estudantes'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Capacidade de Estimular o Interesse'),),
                SizedBox(
                  child: FlutterRating (rating: document2['capacidade de estimular o interesse'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Cumprimento das Regras de Avaliação'),),
                SizedBox(
                  child: FlutterRating (rating: document2['cumprimento das regras de avaliacao'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Disponibilidade'),),
                SizedBox(
                  child: FlutterRating (rating: document2['disponibilidade'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Empenho'),),
                SizedBox(
                  child: FlutterRating (rating: document2['empenho'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Exigência'),),
                SizedBox(
                  child: FlutterRating (rating: document2['exigencia'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Organização dos Conteúdos'),),
                SizedBox(
                  child: FlutterRating (rating: document2['organizacao dos conteudos'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Promoção da Reflexão'),),
                SizedBox(
                  child: FlutterRating (rating: document2['promocao da reflexao'], size: 40, color: Colors.orange),
                ),
                const SizedBox(child: Text('Qualidade do Ensino'),),
                SizedBox(
                  child: FlutterRating (rating: document2['qualidade do ensino'], size: 40, color: Colors.orange),
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