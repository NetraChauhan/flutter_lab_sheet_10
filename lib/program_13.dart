import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF0F766E)),
    home:const App(),
  ));
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Students A–Z',
    subtitle:'Cloud Firestore orderBy(name)',
    color:const Color(0xFF0F766E),
    icon:Icons.sort_by_alpha_rounded,
    child:SizedBox(
      height:430,
      child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance
          .collection('students')
          .orderBy('name')
          .snapshots(),
        builder:(context,snapshot){
          if(snapshot.hasError){
            return Center(child:Text(snapshot.error.toString()));
          }
          if(!snapshot.hasData){
            return const Center(child:CircularProgressIndicator());
          }

          final docs=snapshot.data!.docs;
          return ListView.builder(
            itemCount:docs.length,
            itemBuilder:(context,i){
              final s=docs[i].data();
              return Card(child:ListTile(
                leading:CircleAvatar(child:Text((i+1).toString())),
                title:Text(s['name']?.toString()??''),
                subtitle:Text(
                  (s['roll']?.toString()??'')+' • '+
                  (s['course']?.toString()??''),
                ),
              ));
            },
          );
        },
      ),
    ),
  );
}
