import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF0F766E)),
    home:const Home(),
  ));
}

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context){
    final user=FirebaseAuth.instance.currentUser;
    return LabPage(
      title:'Home',
      subtitle:'Logged-in Firebase user',
      color:const Color(0xFF0F766E),
      icon:Icons.home_rounded,
      centered:true,
      child:Column(children:[
        const CircleAvatar(
          radius:34,
          child:Icon(Icons.person,size:36),
        ),
        const SizedBox(height:14),
        const Text('Logged-in Email',
          style:TextStyle(color:Colors.black54)),
        const SizedBox(height:4),
        Text(user?.email??'No user currently signed in',
          style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
        const SizedBox(height:18),
        OutlinedButton.icon(
          onPressed:()async{
            await FirebaseAuth.instance.signOut();
            if(context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content:Text('Logged out successfully')),
              );
            }
          },
          icon:const Icon(Icons.logout),
          label:const Text('Logout'),
        )
      ]),
    );
  }
}
