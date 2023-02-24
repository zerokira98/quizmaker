import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/bloc/maker_state.dart';
import 'package:quizmaker/nav_rail.dart';
import 'package:quizmaker/preview.dart';
import 'package:quizmaker/texteditor.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final q.QuillController _controller = q.QuillController.basic();
  @override
  void initState() {
    _controller.addListener(textListener);
    super.initState();
  }

  textListener() {
    var plaintext = _controller.document.toPlainText();
    var jsonString = jsonEncode(_controller.document.toDelta().toJson());

    BlocProvider.of<MakerBloc>(context)
        .add(UpdateQuestion(plaintext, jsonString));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<MakerBloc>(context).add(ReturntoInitial());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings),
                label: const Text('Settings')),
            const Padding(padding: EdgeInsets.all(8)),
            ElevatedButton.icon(
                onPressed: () {
                  // print('hei');
                  BlocProvider.of<MakerBloc>(context).add(SavetoFile());
                },
                icon: const Icon(Icons.save),
                label: const Text('Save')),
            const Padding(padding: EdgeInsets.all(8)),
          ],
          title: BlocListener<MakerBloc, MakerState>(
            listenWhen: (previous, current) {
              if (current is MakerLoaded) {
                if (current.saveSuccess != null) {
                  return true;
                }
              }
              return false;
            },
            listener: (context, state) {
              if (state is MakerLoaded) {
                // print('listen');
                if (state.saveSuccess != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${state.saveSuccess}')));
                  Future.delayed(const Duration(seconds: 5)).then((value) =>
                      BlocProvider.of<MakerBloc>(context).add(DeleteSuccess()));
                }
              }
            },
            child: BlocBuilder<MakerBloc, MakerState>(
              builder: (context, state) {
                // print('$state');
                if (state is MakerLoaded) {
                  // print(state.datas.toString());
                  return Text(state.quizTitle);
                }
                return const Text('null');
              },
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              NavRail(_controller),
              Expanded(flex: 1, child: TextEditor(_controller)),
              const Padding(padding: EdgeInsets.all(14)),
              Expanded(flex: 1, child: Preview(_controller)),
              const Padding(padding: EdgeInsets.all(14)),
            ],
          ),
        ),
      ),
    );
  }
}
