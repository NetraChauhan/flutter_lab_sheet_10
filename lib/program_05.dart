import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final email=TextEditingController();
  final pass=TextEditingController();

  Future<void> register()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email:email.text.trim(),
        password:pass.text,
      );
    }on FirebaseAuthException catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(e.message??e.code)),
        );
      }
    }
  }

  Future<void> login()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:email.text.trim(),
        password:pass.text,
      );
    }on FirebaseAuthException catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(e.message??e.code)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Authentication Errors',
    subtitle:'FirebaseAuthException displayed with SnackBar',
    color:const Color(0xFFB91C1C),
    icon:Icons.error_outline_rounded,
    child:Column(children:[
      field(email,'Email'),
      field(pass,'Password',obscure:true),
      Row(children:[
        Expanded(child:FilledButton(
          onPressed:login,
          child:const Text('Login'),
        )),
        const SizedBox(width:10),
        Expanded(child:OutlinedButton(
          onPressed:register,
          child:const Text('Register'),
        )),
      ]),
      const SizedBox(height:12),
      statusBox(
        'Examples: wrong password • invalid email • email already in use',
        const Color(0xFFB91C1C),
      ),
    ]),
  );
}
