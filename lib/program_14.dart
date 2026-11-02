import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF7C3AED)),
    home:const NotesApp(),
  ));
}

class NotesApp extends StatefulWidget{
  const NotesApp({super.key});
  State<NotesApp> createState()=>S();
}

class S extends State<NotesApp>{
  final note=TextEditingController();

  User? get user=>FirebaseAuth.instance.currentUser;

  Future<void> add()async{
    if(user==null)return;
    await FirebaseFirestore.instance.collection('notes').add({
      'uid':user!.uid,
      'text':note.text.trim(),
      'createdAt':FieldValue.serverTimestamp(),
    });
    note.clear();
  }

  @override
  Widget build(BuildContext context){
    if(user==null){
      return LabPage(
        title:'My Notes',
        subtitle:'Cloud Firestore notes for logged-in user',
        color:const Color(0xFF7C3AED),
        icon:Icons.note_alt_rounded,
        centered:true,
        child:statusBox(
          'Please log in first to add, view and delete your notes.',
          const Color(0xFF7C3AED),
        ),
      );
    }

    final query=FirebaseFirestore.instance
      .collection('notes')
      .where('uid',isEqualTo:user!.uid);

    return LabPage(
      title:'My Notes',
      subtitle:'Logged in as '+(user!.email??user!.uid),
      color:const Color(0xFF7C3AED),
      icon:Icons.note_alt_rounded,
      child:Column(children:[
        Row(children:[
          Expanded(child:TextField(
            controller:note,
            decoration:const InputDecoration(hintText:'Write a note...'),
          )),
          const SizedBox(width:8),
          FilledButton(onPressed:add,child:const Text('Add')),
        ]),
        const SizedBox(height:14),
        SizedBox(
          height:360,
          child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
            stream:query.snapshots(),
            builder:(context,snapshot){
              if(snapshot.hasError){
                return Center(child:Text(snapshot.error.toString()));
              }
              if(!snapshot.hasData){
                return const Center(child:CircularProgressIndicator());
              }

              final docs=snapshot.data!.docs;
              if(docs.isEmpty){
                return const Center(child:Text('No notes yet'));
              }

              return ListView(
                children:docs.map((d)=>Card(child:ListTile(
                  leading:const Icon(Icons.sticky_note_2_outlined),
                  title:Text(d.data()['text']?.toString()??''),
                  trailing:IconButton(
                    icon:const Icon(Icons.delete_outline,color:Colors.red),
                    onPressed:()=>d.reference.delete(),
                  ),
                ))).toList(),
              );
            },
          ),
        ),
      ]),
    );
  }
}
