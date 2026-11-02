import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF2563EB)),
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
      return snapshot.data==null?const Login():const Home();
    },
  );
}

class Login extends StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Login Screen',
    subtitle:'No authenticated user',
    color:const Color(0xFF2563EB),
    icon:Icons.login_rounded,
    centered:true,
    child:statusBox(
      'authStateChanges() selected the Login screen',
      const Color(0xFF2563EB),
    ),
  );
}

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Home Screen',
    subtitle:'Authenticated user detected automatically',
    color:const Color(0xFF16A34A),
    icon:Icons.home_rounded,
    centered:true,
    child:Column(children:[
      Text(
        FirebaseAuth.instance.currentUser?.email??'Signed in',
        style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800),
      ),
      const SizedBox(height:14),
      FilledButton.icon(
        onPressed:()=>FirebaseAuth.instance.signOut(),
        icon:const Icon(Icons.logout),
        label:const Text('Logout'),
      ),
    ]),
  );
}
