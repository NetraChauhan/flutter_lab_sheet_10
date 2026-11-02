import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final email=TextEditingController();
  final pass=TextEditingController();
  String msg='';

  Future<void> register()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email:email.text.trim(),
        password:pass.text,
      );
      setState(()=>msg='User registered successfully');
    }on FirebaseAuthException catch(e){
      setState(()=>msg=e.message??e.code);
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Create Account',
    subtitle:'Firebase Authentication registration',
    color:const Color(0xFF7C3AED),
    icon:Icons.person_add_alt_1_rounded,
    centered:true,
    child:Column(children:[
      field(email,'Email'),
      field(pass,'Password',obscure:true),
      SizedBox(
        width:double.infinity,
        child:FilledButton(
          onPressed:register,
          child:const Text('Register'),
        ),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:14),
        statusBox(msg,const Color(0xFF7C3AED)),
      ]
    ]),
  );
}
