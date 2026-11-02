import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFFEA580C)),
    home:const App(),
  ));
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final email=TextEditingController();
  String msg='';

  Future<void> reset()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email:email.text.trim(),
      );
      setState(()=>msg='Password reset email sent');
    }on FirebaseAuthException catch(e){
      setState(()=>msg=e.message??e.code);
    }
  }

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Reset Password',
    subtitle:'sendPasswordResetEmail()',
    color:const Color(0xFFEA580C),
    icon:Icons.lock_reset_rounded,
    centered:true,
    child:Column(children:[
      field(email,'Registered Email'),
      SizedBox(
        width:double.infinity,
        child:FilledButton.icon(
          onPressed:reset,
          icon:const Icon(Icons.email_outlined),
          label:const Text('Send Reset Email'),
        ),
      ),
      if(msg.isNotEmpty)...[
        const SizedBox(height:14),
        statusBox(msg,const Color(0xFFEA580C)),
      ]
    ]),
  );
}
