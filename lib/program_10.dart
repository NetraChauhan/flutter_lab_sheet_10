import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFFD97706)),
    home:const App(),
  ));
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final id=TextEditingController();
  final name=TextEditingController();
  final course=TextEditingController();
  String msg='';

  Future<void> update()async{
    try{
      await FirebaseFirestore.instance
        .collection('students')
        .doc(id.text.trim())
        .update({
          'name':name.text.trim(),
          'course':course.text.trim(),
        });
      setState(()=>msg='Student record updated');
    }catch(e){
      setState(()=>msg='Update failed: '+e.toString());
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Update Student',
    subtitle:'Update an existing Cloud Firestore document',
    color:const Color(0xFFD97706),
    icon:Icons.edit_rounded,
    child:Column(children:[
      field(id,'Document ID'),
      field(name,'Updated Name'),
      field(course,'Updated Course'),
      SizedBox(
        width:double.infinity,
        child:FilledButton.icon(
          onPressed:update,
          icon:const Icon(Icons.save),
          label:const Text('Update Record'),
        ),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:14),
        statusBox(msg,const Color(0xFFD97706)),
      ],
    ]),
  );
}
