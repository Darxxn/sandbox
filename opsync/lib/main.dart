import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/register_screen.dart';
import 'viewmodels/register_vm.dart';
import 'viewmodels/chat_vm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: RegisterScreen(),
      ),
    );
  }
}
