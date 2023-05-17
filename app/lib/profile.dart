import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teachmewell/faculty.dart';
import 'package:teachmewell/course.dart';
import 'package:teachmewell/teacher.dart';
import 'package:teachmewell/faculty.dart';
import 'package:teachmewell/login_register.dart';
import 'package:teachmewell/my_messages.dart';
import 'globals.dart' as globals;

class Profile extends StatelessWidget{
  final String uemail;
  Profile(this.uemail);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF2574A8),
        actions: const [],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.bottomCenter,
            child: Text(uemail.substring(0, 11),
              style: const TextStyle(fontSize: 30),)
          ),
          Container(
            height: 100,
            alignment: Alignment.topCenter,
            child: Text(uemail,
              style: const TextStyle(fontSize: 20)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Faculties(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2574A8),
                  minimumSize: Size(MediaQuery.of(context).size.width/2.4, MediaQuery.of(context).size.width/2.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Column(
                    children: [
                      Image.asset('media/icon.png', width: 100),
                      const Text("Faculdades")
                    ],
                  )
              )
              ),
              Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllTeachersPage()
                  ));
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2574A8),
                    minimumSize: Size(MediaQuery.of(context).size.width/2.4, MediaQuery.of(context).size.width/2.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )
                ),
                child: Column(
                  children: [
                    Image.asset('media/search_icon.png', width: 100),
                    const Text("Pesquisa")
                  ],
                )
              )
              ),
            ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyMessages(202108677), //int.parse(uemail.substring(2, 11)
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2574A8),
                      minimumSize: Size(MediaQuery.of(context).size.width/2.4, MediaQuery.of(context).size.width/2.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                    ),
                    child: Column(
                      children: [
                        Image.asset('media/message_icon.png', width: 100),
                        const Text("Minhas Mensagens")
                      ],
                    )
                )
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: (){
                      // Isto em principio é para mudar, eu é fiz isto para desenrascar
                      Navigator.popUntil(context, (route) => false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2574A8),
                      minimumSize: Size(MediaQuery.of(context).size.width/2.4, MediaQuery.of(context).size.width/2.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          child:Image.asset('media/logout_icon.png', width: 10),
                        ),
                        const Text("Logout")
                      ],
                    )
                )
                ),
              ]
          ),
        ],
      )
    );
  }
}
