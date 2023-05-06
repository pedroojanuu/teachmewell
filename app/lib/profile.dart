import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/faculty.dart';
import 'package:teachmewell/course.dart';
import 'package:teachmewell/teacher.dart';
import 'package:teachmewell/faculty.dart';

class Profile extends StatelessWidget{
  final String uemail;
  Profile(this.uemail);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color(0xFF2574A8),
        actions: [],
      ),
      body: Column(
        children: [
          Text(uemail.substring(0, 11)),
          Text(uemail),
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Faculties(),
                  ));
                },
                child: const Text("Faculdades"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2574A8),
                )
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllTeachersPage()
                  ));
                },
                child: const Text("Pesquisa de Docentes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2574A8),
                )
              )
            ],
          ),
        ],
      )
    );
  }
}
