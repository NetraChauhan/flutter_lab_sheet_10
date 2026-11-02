import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF7C3AED)),
    home:const App(),
  ));
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final name=TextEditingController();
  final roll=TextEditingController();
  final course=TextEditingController();
  String msg='';

  Future<void> add()async{
    try{
      await FirebaseFirestore.instance.collection('students').add({
        'name':name.text.trim(),
        'roll':roll.text.trim(),
        'course':course.text.trim(),
      });
      setState(()=>msg='Student added to Cloud Firestore');
      name.clear();roll.clear();course.clear();
    }catch(e){
      setState(()=>msg='Firestore error: '+e.toString());
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Add Student',
    subtitle:'Cloud Firestore collection: students',
    color:const Color(0xFF7C3AED),
    icon:Icons.person_add_alt_1_rounded,
    child:Column(children:[
      field(name,'Name'),
      field(roll,'Roll Number'),
      field(course,'Course'),
      SizedBox(
        width:double.infinity,
        child:FilledButton(
          onPressed:add,
          child:const Text('Add Student'),
        ),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:14),
        statusBox(msg,const Color(0xFF7C3AED)),
      ]
    ]),
  );
}
