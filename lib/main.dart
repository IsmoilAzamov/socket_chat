
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socket/presentation/chat_page/chat_page.dart';

import 'domain/chat_model.dart';

late Box box;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Hive.initFlutter();

   registerAdapters();

   box = await Hive.openBox('box');

  runApp(const MyApp());

}

void registerAdapters() {
  Hive.registerAdapter(MessageModelAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const title = 'Mutaxassis bilan chat';
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: ChatPage(
        title: title,
      ),
    );
  }
}