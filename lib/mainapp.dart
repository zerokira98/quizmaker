import 'dart:convert';
import 'dart:io';

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
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14),
            child: Preview(_controller),
          ),
        ),
        appBar: AppBar(
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                        child: Column(
                          children: [
                            const Text('Settings'),
                            ElevatedButton(
                                onPressed: () {},
                                child: const Text('Export QuizData')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'))
                          ],
                        ),
                      );
                    },
                  );
                },
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
                if (state.saveSuccess != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          state.saveSuccess! ? 'Success' : 'Error occured')));
                }
              }
            },
            child: BlocBuilder<MakerBloc, MakerState>(
              builder: (context, state) {
                if (state is MakerLoaded) {
                  return Text(state.quizTitle);
                }
                return const Text('null');
              },
            ),
          ),
        ),
        body: BlocListener<MakerBloc, MakerState>(
          listenWhen: (prev, curr) {
            // print('prev:$prev');
            if (prev is MakerInitial) {
              if (curr is MakerLoaded) {
                return true;
              }
            }
            if (prev is MakerLoaded && curr is MakerLoaded) {
              if (prev.aSelectedIndex != null && curr.aSelectedIndex == null) {
                return true;
              }
              return prev.qSelectedIndex != curr.qSelectedIndex;
            }
            return false;
          },
          listener: (context, state) {
            if (state is MakerLoaded) {
              // print(a);
              if (state.aSelectedIndex == null) {
                String a = state.datas[state.qSelectedIndex].textJson ??
                    '[{"insert":"\\n"}]';
                try {
                  var json = jsonDecode(a);
                  _controller.document = q.Document.fromJson(json);
                  _controller.moveCursorToEnd();
                } catch (e) {
                  debugPrint('error$e');
                }
              } else {}
            }
          },
          child: BlocListener<MakerBloc, MakerState>(
            listenWhen: (prev, curr) {
              if (prev is MakerLoaded && curr is MakerLoaded) {
                if (curr.aSelectedIndex == null) {
                  return false;
                }
                return prev.aSelectedIndex != curr.aSelectedIndex;
              }
              return false;
            },
            listener: (context, state) {
              if (state is MakerLoaded) {
                String a = state.datas[state.qSelectedIndex]
                            .answers[state.aSelectedIndex!].text ==
                        ''
                    ? '[{"insert":"\\n"}]'
                    : state.datas[state.qSelectedIndex]
                        .answers[state.aSelectedIndex!].text!;
                try {
                  var json = jsonDecode(a);
                  _controller.document = q.Document.fromJson(json);
                  _controller.moveCursorToEnd();
                } catch (e) {
                  debugPrint('error$e');
                }
              }
            },
            child: BlocBuilder<MakerBloc, MakerState>(
              buildWhen: (previous, current) =>
                  !((previous is MakerLoaded) && (current is MakerLoaded)),
              builder: (context, state) {
                if (state is MakerLoaded) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        NavRail(_controller),
                        Expanded(flex: 1, child: TextEditor(_controller)),
                        Platform.isWindows
                            ? Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14.0, right: 14),
                                  child: Preview(_controller),
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  );
                }
                if (state is MakerError) {
                  return Center(child: Text(state.msg));
                }
                if (state is MakerInitial) {
                  return const Center(child: Text('Initializing'));
                }
                return const Center(child: Text('null'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
