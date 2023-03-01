import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/bloc/maker_state.dart';

class TextEditor extends StatefulWidget {
  final q.QuillController controller;
  const TextEditor(this.controller, {super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all()),
        child: Column(children: [
          Row(
            children: [
              BlocBuilder<MakerBloc, MakerState>(
                builder: (context, state) {
                  if (state is MakerLoaded) {
                    String content = state.aSelectedIndex != null
                        ? 'Answer ${state.aSelectedIndex}'
                        : 'Question';
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(content),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              // DropdownButton(
              //   items: const [
              //     DropdownMenuItem(value: 0, child: Text('Question')),
              //     DropdownMenuItem(value: 1, child: Text('Answer no1')),
              //     DropdownMenuItem(value: 2, child: Text('Answer no2')),
              //     DropdownMenuItem(value: 3, child: Text('Answer no3')),
              //   ],
              //   value: 0,
              //   onChanged: (value) {},
              // ),
              Expanded(child: Container()),
              ElevatedButton.icon(
                  onPressed: () {
                    var state = (BlocProvider.of<MakerBloc>(context).state
                        as MakerLoaded);
                    BlocProvider.of<MakerBloc>(context)
                        .add(DeleteQuestion(state.qSelectedIndex!));
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Question'))
            ],
          ),
          q.QuillToolbar.basic(
            controller: widget.controller,
            showAlignmentButtons: false,
            showDirection: false,
            showBackgroundColorButton: false,
            // showJustifyAlignment: false,
            // showCenterAlignment: false,
            showHeaderStyle: false,
            showSearchButton: false,
            showListCheck: false,
            showCodeBlock: false,
            // showIndent: false,
          ),
          Expanded(
              child: BlocListener<MakerBloc, MakerState>(
            listenWhen: (prev, curr) {
              // print('prev:$prev');
              if (prev is MakerInitial) {
                if (curr is MakerLoaded) {
                  return true;
                }
              }
              if (prev is MakerLoaded && curr is MakerLoaded) {
                if (prev.aSelectedIndex != null &&
                    curr.aSelectedIndex == null) {
                  return true;
                }
                return (prev).qSelectedIndex != curr.qSelectedIndex;
              }
              return false;
            },
            listener: (context, state) {
              if (state is MakerLoaded) {
                // print(a);
                if (state.aSelectedIndex == null) {
                  String a = state.datas[state.qSelectedIndex!].textJson ??
                      '[{"insert":"\\n"}]';
                  try {
                    var json = jsonDecode(a);
                    widget.controller.document = q.Document.fromJson(json);
                    widget.controller.moveCursorToEnd();
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
                  String a = state.datas[state.qSelectedIndex!]
                          .answers[state.aSelectedIndex!].text ??
                      '';

                  widget.controller.document = q.Document.fromJson([
                    {"insert": "${a.trim()}\n"}
                  ]);
                  widget.controller.moveCursorToEnd();
                }
              },
              child: q.QuillEditor.basic(
                controller: widget.controller,
                readOnly: false, // true for view only mode
              ),
            ),
          ))
        ]));
  }
}
