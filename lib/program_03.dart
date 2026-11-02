import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF0369A1)),
    home:const App(),
  ));
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final email=TextEditingController();
  final pass=TextEditingController();
  String msg='';

  Future<void> login()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:email.text.trim(),
        password:pass.text,
      );
      setState(()=>msg='Login successful');
    }on FirebaseAuthException catch(e){
      setState(()=>msg=e.message??e.code);
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Firebase Login',
    subtitle:'signInWithEmailAndPassword()',
    color:const Color(0xFF0369A1),
    icon:Icons.login_rounded,
    centered:true,
    child:Column(children:[
      field(email,'Email'),
      field(pass,'Password',obscure:true),
      SizedBox(
        width:double.infinity,
        child:FilledButton(onPressed:login,child:const Text('Login')),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:14),
        statusBox(msg,const Color(0xFF0369A1)),
      ]
    ]),
  );
}
