import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/nav_rail.dart';
import 'package:quizmaker/preview.dart';
import 'package:quizmaker/texteditor.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => MakerBloc(),
    child: MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        home: HomePage()),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('quizmaker'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InitiateNewQuiz()));
            },
            child: Text('Create new Quiz')),
      ),
    );
  }
}

class InitiateNewQuiz extends StatelessWidget {
  InitiateNewQuiz({super.key});
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Quiz Baru'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(label: Text('Judul Quiz')),
                  )),
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        BlocProvider.of<MakerBloc>(context)
                            .add(Initialize(title: titleController.text));
                        return MyApp();
                      },
                    ));
                  },
                  child: Text('Buat'))
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final q.QuillController _controller = q.QuillController.basic();
  @override
  void initState() {
    _controller.addListener(textListener);
    super.initState();
  }

  textListener() {
    var plaintext = _controller.document.toPlainText();
    var jsonString = jsonEncode(_controller.document.toDelta().toJson());
    // if (a.isNotEmpty)
    BlocProvider.of<MakerBloc>(context)
        .add(UpdateQuestion(plaintext, jsonString));
    // print('$plaintext\n$jsonString');
    // _controller.document = q.Document.fromJson(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MakerBloc, MakerState>(
          builder: (context, state) {
            // print('$state');
            if (state is MakerLoaded) {
              // print(state.datas.toString());
              return Text('${state.quizTitle}');
            }
            return Text('null');
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            NavRail(_controller),
            Expanded(flex: 1, child: TextEditor(_controller)),
            const Padding(padding: EdgeInsets.all(4)),
            Expanded(flex: 1, child: Preview(_controller)),
          ],
        ),
      ),
    );
  }
}
