import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://tmeriosndjiwpbdjljcp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtZXJpb3NuZGppd3BiZGpsamNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3NDQ0ODUsImV4cCI6MjA1NzMyMDQ4NX0.1jOlCxEna20DcmLzibrgp9FuGSTp8snKu5afujJaW1A',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figma Mockup Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        // '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
