import 'package:flutter/material.dart';

ThemeData labTheme(Color seed)=>ThemeData(
  useMaterial3:true,
  colorScheme:ColorScheme.fromSeed(seedColor:seed),
  scaffoldBackgroundColor:const Color(0xFFF7F8FC),
  inputDecorationTheme:InputDecorationTheme(
    filled:true,
    fillColor:Colors.white,
    border:OutlineInputBorder(
      borderRadius:BorderRadius.circular(14),
      borderSide:BorderSide.none,
    ),
  ),
  cardTheme:CardThemeData(
    elevation:0,
    color:Colors.white,
    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)),
  ),
);

class LabPage extends StatelessWidget{
  final String title,subtitle;
  final Color color;
  final IconData icon;
  final Widget child;
  final bool centered;

  const LabPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.child,
    this.centered=false,
  });

  @override
  Widget build(BuildContext context)=>Scaffold(
    body:SafeArea(
      child:Center(
        child:ConstrainedBox(
          constraints:const BoxConstraints(maxWidth:820),
          child:ListView(
            padding:const EdgeInsets.all(26),
            children:[
              if(centered)
                Column(children:[
                  CircleAvatar(
                    radius:34,
                    backgroundColor:color.withOpacity(.12),
                    child:Icon(icon,size:34,color:color),
                  ),
                  const SizedBox(height:12),
                  Text(title,textAlign:TextAlign.center,
                    style:const TextStyle(fontSize:30,fontWeight:FontWeight.w800)),
                  const SizedBox(height:4),
                  Text(subtitle,textAlign:TextAlign.center,
                    style:const TextStyle(color:Colors.black54)),
                ])
              else
                Container(
                  padding:const EdgeInsets.all(22),
                  decoration:BoxDecoration(
                    gradient:LinearGradient(colors:[color,color.withOpacity(.72)]),
                    borderRadius:BorderRadius.circular(24),
                  ),
                  child:Row(children:[
                    Container(
                      width:58,height:58,
                      decoration:BoxDecoration(
                        color:Colors.white.withOpacity(.16),
                        borderRadius:BorderRadius.circular(18),
                      ),
                      child:Icon(icon,color:Colors.white,size:30),
                    ),
                    const SizedBox(width:16),
                    Expanded(child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        Text(title,style:const TextStyle(
                          color:Colors.white,fontSize:27,fontWeight:FontWeight.w800)),
                        const SizedBox(height:4),
                        Text(subtitle,style:TextStyle(color:Colors.white.withOpacity(.86))),
                      ],
                    )),
                  ]),
                ),
              const SizedBox(height:20),
              Container(
                padding:const EdgeInsets.all(20),
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(22),
                  boxShadow:[
                    BoxShadow(
                      color:color.withOpacity(.08),
                      blurRadius:22,
                      offset:const Offset(0,8),
                    )
                  ],
                ),
                child:child,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget field(TextEditingController c,String label,{bool obscure=false})=>Padding(
  padding:const EdgeInsets.only(bottom:12),
  child:TextField(
    controller:c,
    obscureText:obscure,
    decoration:InputDecoration(labelText:label),
  ),
);

Widget statusBox(String text,Color color)=>Container(
  width:double.infinity,
  padding:const EdgeInsets.all(14),
  decoration:BoxDecoration(
    color:color.withOpacity(.08),
    borderRadius:BorderRadius.circular(14),
  ),
  child:Text(text,style:TextStyle(color:color,fontWeight:FontWeight.w700)),
);
