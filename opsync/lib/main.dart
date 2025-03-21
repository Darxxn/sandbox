import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'screens/register_screen.dart';
import 'screens/chat_screen.dart';
import 'viewmodels/register_vm.dart';
import 'viewmodels/chat_vm.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env"); // Ensure the .env file is in your project root
    print("✅ .env file loaded successfully!");
  } catch (e) {
    print("❌ Error loading .env file: $e");
  }

  // Initialize Supabase with values from the .env file
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!, 
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  print("✅ Supabase initialized!");

  // Optional: Test the connection by querying a known table (e.g., 'organizations')
  try {
    final List<dynamic> testQuery = await Supabase.instance.client
        .from('organizations')
        .select()
        .limit(1);
    print("✅ Test query succeeded. Organizations table returned: $testQuery");
  } catch (error) {
    print("❌ Test query failed: $error");
  }

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
        title: 'Figma Mockup Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/', // Set Login Screen as the entry point
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
