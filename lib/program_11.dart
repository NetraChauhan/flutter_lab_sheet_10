import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFFB91C1C)),
    home:const App(),
  ));
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Delete Student',
    subtitle:'Delete Cloud Firestore student records',
    color:const Color(0xFFB91C1C),
    icon:Icons.delete_forever_rounded,
    child:SizedBox(
      height:430,
      child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance
          .collection('students')
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
            return const Center(child:Text('No student records found'));
          }

          return ListView.builder(
            itemCount:docs.length,
            itemBuilder:(context,i){
              final d=docs[i];
              final s=d.data();
              return Card(child:ListTile(
                title:Text(s['name']?.toString()??''),
                subtitle:Text(
                  (s['roll']?.toString()??'')+' • '+
                  (s['course']?.toString()??''),
                ),
                trailing:IconButton(
                  icon:const Icon(Icons.delete_outline,color:Colors.red),
                  onPressed:()=>FirebaseFirestore.instance
                    .collection('students')
                    .doc(d.id)
                    .delete(),
                ),
              ));
            },
          );
        },
      ),
    ),
  );
}
