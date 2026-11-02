import 'package:flutter/material.dart';
import 'firebase_setup.dart';
import 'lab_ui.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    theme:labTheme(const Color(0xFF4F46E5)),
    home:const App(),
  ));
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context)=>LabPage(
    title:'Firebase Connected',
    subtitle:'Firebase initialized using firebase_core',
    color:const Color(0xFF4F46E5),
    icon:Icons.cloud_done_rounded,
    centered:true,
    child:Column(children:[
      const Icon(Icons.check_circle_rounded,
        size:72,color:Color(0xFF16A34A)),
      const SizedBox(height:14),
      const Text('Firebase Connected',
        style:TextStyle(fontSize:24,fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      const Text('Firebase.initializeApp() completed successfully'),
    ]),
  );
}
