import 'package:chatting_1/views/auth/auth_gate_view.dart';
import 'package:chatting_1/views/home/home_main.dart';
import 'package:chatting_1/views/home/profile_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase 초기화 실패 처리
    print("Firebase Initialization Failed: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeMain(),
      ),
    );
  }
}
