// import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/signup/signup_cubit.dart';
import 'package:quizmaker/pages/signup/signupform.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';
// import 'package:flutter_firebase_login/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return CupertinoPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'res/bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                  '<a href="http://www.freepik.com">Designed by Harryarts / Freepik</a>')),
          Container(
            color: Theme.of(context).canvasColor,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: BlocProvider<SignUpCubit>(
                  create: (_) =>
                      SignUpCubit(context.read<AuthenticationRepository>()),
                  child: const SignUpForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
