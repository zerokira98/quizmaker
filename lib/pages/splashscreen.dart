import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/main.dart';
import 'package:quizmaker/pages/loginpage/loginpage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AppStatus.authenticated:
            return HomePage();
          case AppStatus.unauthenticated:
            return LoginPage();
          default:
            return Center(
              child: Text('Weird State'),
            );
        }
      },
    );
  }
}
