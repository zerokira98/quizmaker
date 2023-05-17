import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_bloc.dart';
import 'package:quizmaker/pages/splashscreen.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';
import 'package:quizmaker/msc/themedata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
      name: Platform.isAndroid ? 'quizmaker' : null,
      options: const FirebaseOptions(
          apiKey: "AIzaSyDebeOIE8-ePsMle-VqkSqoCTwpvo0L_pg",
          authDomain: "quizmaker-d31da.firebaseapp.com",
          projectId: "quizmaker-d31da",
          storageBucket: "quizmaker-d31da.appspot.com",
          messagingSenderId: "50900342589",
          appId: "1:50900342589:web:8b6b8b6aa4bd1ce7ef1754",
          measurementId: "G-S9PDMQS23V"));
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
      ],
      child: MaterialApp(
          themeMode: ThemeMode.system,
          theme: ThemeDatas().lightTheme(),
          darkTheme: ThemeDatas().darkTheme(),
          home: const SplashScreen()),
    ),
  ));
}
