
import 'package:flutter/material.dart';
import 'package:socket/presentation/chat/chat_page.dart';


Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const title = 'Support Chat';
    return const MaterialApp(
      title: title,
      home: ChatPage(
        title: title,
      ),
    );
  }
}