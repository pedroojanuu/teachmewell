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
                child: Column(
                    children: [
                      Image.asset('media/icon.png', width: 100),
                      Text("Faculdades")
                    ],
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2574A8),
                  minimumSize: Size(190, 200),
                )
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllTeachersPage()
                  ));
                },
                child: Column(
                  children: [
                    Image.asset('media/icon.png', width: 100),
                    Text("Pesquisa")
                  ],
                ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2574A8),
                    minimumSize: Size(190, 200),
                )
              )
            ],
              mainAxisAlignment: MainAxisAlignment.center
          ),
        ],
      )
    );
  }
}
