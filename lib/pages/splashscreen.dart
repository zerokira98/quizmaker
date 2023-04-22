import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/pages/homepage.dart';
import 'package:quizmaker/pages/loginpage/loginpage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AppStatus.authenticated:
            return const HomePage();
          case AppStatus.unauthenticated:
            return const LoginPage();
          default:
            return const Center(
              child: Text('Weird State'),
            );
        }
      },
    );
  }
}
