import 'package:chatting_1/views/auth/login_or_register_view.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo1_view.dart';
import 'package:chatting_1/views/home/home_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/utils/route.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            final user = snapshot.data!;
            final uid = user.uid;

            return FutureBuilder<bool>(
              future: checkIsCollected(uid),
              builder: (context, futureSnap) {
                if (futureSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (futureSnap.hasError) {
                  return Center(child: Text("에러 발생: ${futureSnap.error}"));
                }
                if (!futureSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final isCollected = futureSnap.data!;
                if (isCollected) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppRoutes.pushAndRemoveUntil(
                      context,
                      const HomeMain(),
                      predicate: (route) => false,
                    );
                  });

                  return const SizedBox();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppRoutes.pushAndRemoveUntil(
                      context,
                      RegisterCollectUserInfoFirstScreen(),
                      predicate: (route) => false,
                    );
                  });
                  return const SizedBox();
                }
              },
            );
          } else {
            return LoginOrRegisterScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkIsCollected(String uid) async {
    final dbRef = FirebaseDatabase.instance.ref('users/$uid/isCollected');
    final snapshot = await dbRef.get();
    if (!snapshot.exists) {
      return false;
    }
    final value = snapshot.value;
    if (value is bool) {
      return value;
    }
    return false;
  }
}
