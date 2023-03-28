import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/bloc/login/login_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_bloc.dart';
import 'package:quizmaker/pages/loginpage/loginpage.dart';
import 'package:quizmaker/pages/quiz_creator/home.dart';
import 'package:quizmaker/pages/quiz_creator/mainapp.dart';
import 'package:quizmaker/pages/splashscreen.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';
import 'package:quizmaker/service/file_service.dart';
import 'package:quizmaker/msc/themedata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDebeOIE8-ePsMle-VqkSqoCTwpvo0L_pg",
          authDomain: "quizmaker-d31da.firebaseapp.com",
          projectId: "quizmaker-d31da",
          storageBucket: "quizmaker-d31da.appspot.com",
          messagingSenderId: "50900342589",
          appId: "1:50900342589:web:8b6b8b6aa4bd1ce7ef1754",
          measurementId: "G-S9PDMQS23V"));
  // var authrepo = AuthenticationRepository(
  //     firebaseAuth: FirebaseAuth.instance,
  //     googleSignIn: GoogleSignIn.standard());
  runApp(RepositoryProvider(
    create: (context) => AuthenticationRepository(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MakerBloc(
              repo: RepositoryProvider.of<AuthenticationRepository>(context)),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context)),
        ),
        // BlocProvider(
        //   create: (context) => LoginCubit(
        //       RepositoryProvider.of<AuthenticationRepository>(context)),
        //   child: Container(),
        // )
      ],
      child: MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeDatas().lightTheme(),
          darkTheme: ThemeDatas().darkTheme(),
          home: const SplashScreen()),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Welcome, ${context.read<AuthenticationRepository>().currentUser.id}'),
        actions: [
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AppLogoutRequested());
              },
              child: Text('LogOut'))
        ],
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                  width: 192,
                  height: 192,
                  child: Card(
                    child: Center(
                      child: Text('Take Test'),
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(HomePageCreate.route());
              },
              child: Container(
                  width: 192,
                  height: 192,
                  child: Card(
                    child: Center(
                      child: Text('Create Quiz'),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
