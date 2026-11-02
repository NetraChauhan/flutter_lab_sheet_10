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
    theme:labTheme(const Color(0xFF312E81)),
    home:const AuthGate(),
  ));
}

class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context)=>StreamBuilder<User?>(
    stream:FirebaseAuth.instance.authStateChanges(),
    builder:(context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Scaffold(
          body:Center(child:CircularProgressIndicator()),
        );
      }
      return snapshot.data==null?const Login():const Students();
    },
  );
}

class Login extends StatefulWidget{
  const Login({super.key});
  State<Login> createState()=>LoginState();
}

class LoginState extends State<Login>{
  final email=TextEditingController();
  final pass=TextEditingController();
  String msg='';

  Future<void> login()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:email.text.trim(),
        password:pass.text,
      );
    }on FirebaseAuthException catch(e){
      setState(()=>msg=e.message??e.code);
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Student Management Login',
    subtitle:'Firebase Authentication',
    color:const Color(0xFF312E81),
    icon:Icons.admin_panel_settings_rounded,
    centered:true,
    child:Column(children:[
      field(email,'Email'),
      field(pass,'Password',obscure:true),
      SizedBox(
        width:double.infinity,
        child:FilledButton(onPressed:login,child:const Text('Login')),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:12),
        statusBox(msg,const Color(0xFFB91C1C)),
      ],
    ]),
  );
}

class Students extends StatelessWidget{
  const Students({super.key});

  Future<void> deleteStudent(String id)async{
    await FirebaseFirestore.instance
      .collection('students')
      .doc(id)
      .delete();
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(
      title:const Text('Student Management'),
      actions:[
        IconButton(
          onPressed:()=>FirebaseAuth.instance.signOut(),
          icon:const Icon(Icons.logout),
        )
      ],
    ),
    floatingActionButton:FloatingActionButton.extended(
      onPressed:()=>Navigator.push(
        context,
        MaterialPageRoute(builder:(_)=>const StudentForm()),
      ),
      icon:const Icon(Icons.add),
      label:const Text('Add Student'),
    ),
    body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
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
        if(docs.isEmpty){
          return const Center(child:Text('No student records'));
        }

        return ListView.builder(
          padding:const EdgeInsets.all(18),
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
              onTap:()=>Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>StudentForm(
                    id:d.id,
                    student:s,
                  ),
                ),
              ),
              trailing:IconButton(
                icon:const Icon(Icons.delete_outline,color:Colors.red),
                onPressed:()=>deleteStudent(d.id),
              ),
            ));
          },
        );
      },
    ),
  );
}

class StudentForm extends StatefulWidget{
  final String? id;
  final Map<String,dynamic>? student;

  const StudentForm({super.key,this.id,this.student});

  State<StudentForm> createState()=>FormStatePage();
}

class FormStatePage extends State<StudentForm>{
  final name=TextEditingController();
  final roll=TextEditingController();
  final course=TextEditingController();

  void initState(){
    super.initState();
    final s=widget.student;
    if(s!=null){
      name.text=s['name']?.toString()??'';
      roll.text=s['roll']?.toString()??'';
      course.text=s['course']?.toString()??'';
    }
  }

  Future<void> save()async{
    final data={
      'name':name.text.trim(),
      'roll':roll.text.trim(),
      'course':course.text.trim(),
    };

    final col=FirebaseFirestore.instance.collection('students');

    if(widget.id==null){
      await col.add(data);
    }else{
      await col.doc(widget.id).update(data);
    }

    if(mounted)Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(
      title:Text(widget.id==null?'Add Student':'Update Student'),
    ),
    body:ListView(
      padding:const EdgeInsets.all(24),
      children:[
        field(name,'Name'),
        field(roll,'Roll Number'),
        field(course,'Course'),
        FilledButton(
          onPressed:save,
          child:Text(widget.id==null?'Add Student':'Update Student'),
        ),
      ],
    ),
  );
}
