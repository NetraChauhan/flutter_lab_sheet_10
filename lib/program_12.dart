import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF2563EB)),
    home:const App(),
  ));
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  String course='BCA';

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Students by Course',
    subtitle:'Cloud Firestore where() query',
    color:const Color(0xFF2563EB),
    icon:Icons.filter_alt_rounded,
    child:Column(children:[
      DropdownButton<String>(
        value:course,
        isExpanded:true,
        items:['BCA','BBA','MCA'].map((x)=>
          DropdownMenuItem(value:x,child:Text(x))
        ).toList(),
        onChanged:(v)=>setState(()=>course=v!),
      ),
      const SizedBox(height:12),
      SizedBox(
        height:360,
        child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream:FirebaseFirestore.instance
            .collection('students')
            .where('course',isEqualTo:course)
            .snapshots(),
          builder:(context,snapshot){
            if(snapshot.hasError){
              return Center(child:Text(snapshot.error.toString()));
            }
            if(!snapshot.hasData){
              return const Center(child:CircularProgressIndicator());
            }

            final docs=snapshot.data!.docs;
            if(docs.isEmpty){
              return Center(child:Text('No '+course+' students found'));
            }

            return ListView(
              children:docs.map((d){
                final s=d.data();
                return Card(child:ListTile(
                  title:Text(s['name']?.toString()??''),
                  subtitle:Text(s['roll']?.toString()??''),
                  trailing:Chip(label:Text(course)),
                ));
              }).toList(),
            );
          },
        ),
      ),
    ]),
  );
}
