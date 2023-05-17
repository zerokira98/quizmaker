import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/pages/quiz_checker/quiz_checker.dart';
import 'package:quizmaker/pages/quiz_creator/home.dart';
import 'package:quizmaker/pages/quiz_take/quiztake_home.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // centerTitle: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Welcome, ${context.read<AuthenticationRepository>().currentUser.id}',
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            // title: Text(
            //     'Welcome, ${context.read<AuthenticationRepository>().currentUser.id}'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(const AppLogoutRequested());
                  },
                  child: const Text('LogOut'))
            ],
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Wrap(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(QuizTakeHome.route());
                    },
                    child: const SizedBox(
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
                    child: const SizedBox(
                        width: 192,
                        height: 192,
                        child: Card(
                          child: Center(
                            child: Text('Create Quiz'),
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QuizCheckerPage(),
                      ));
                    },
                    child: const SizedBox(
                        width: 192,
                        height: 192,
                        child: Card(
                          child: Center(
                            child: Text('Check Quiz'),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
