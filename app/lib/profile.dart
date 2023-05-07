import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/faculty.dart';
import 'package:teachmewell/course.dart';
import 'package:teachmewell/teacher.dart';
import 'package:teachmewell/faculty.dart';
import 'package:teachmewell/login_register.dart';
import 'package:teachmewell/my_messages.dart';

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
          Container(
            child: Text(uemail.substring(0, 11),
              style: TextStyle(fontSize: 30),),
            height: 100,
            alignment: Alignment.bottomCenter
          ),
          Container(
            child: Text(uemail,
              style: TextStyle(fontSize: 20)),
            height: 100,
            alignment: Alignment.topCenter,
          ),
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
                    Image.asset('media/search_icon.png', width: 100),
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
          Row(
              children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyMessages(202108677), //int.parse(uemail.substring(2, 11)
                      ));
                    },
                    child: Column(
                      children: [
                        Image.asset('media/message_icon.png', width: 100),
                        Text("Minhas Mensagens")
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2574A8),
                      minimumSize: Size(190, 200),
                    )
                ),
                ElevatedButton(
                    onPressed: (){
                      // Isto em principio é para mudar, eu é fiz isto para desenrascar
                      Navigator.popUntil(context, (route) => false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()
                      ));
                    },
                    child: Column(
                      children: [
                        Container(
                          child:Image.asset('media/logout_icon.png', width: 10),
                          width: 100,
                        ),
                        Text("Logout")
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
