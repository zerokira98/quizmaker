import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_quill/src/widgets/controller.dart';
import 'package:quizmaker/bloc/maker_bloc.dart';

class TextEditor extends StatefulWidget {
  final QuillController controller;
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
              DropdownButton(
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Question')),
                  DropdownMenuItem(value: 1, child: Text('Answer no1')),
                  DropdownMenuItem(value: 2, child: Text('Answer no2')),
                  DropdownMenuItem(value: 3, child: Text('Answer no3')),
                ],
                value: 0,
                onChanged: (value) {},
              ),
              Expanded(child: Container()),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  label: Text('Delete Question'))
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
              child: Container(
            child: BlocListener<MakerBloc, MakerState>(
              listenWhen: (prev, curr) {
                if (prev is MakerLoaded) {
                  return (prev as MakerLoaded).qSelectedIndex !=
                      (curr as MakerLoaded).qSelectedIndex;
                }
                return false;
              },
              listener: (context, state) {
                if (state is MakerLoaded) {
                  String a = state.datas[state.qSelectedIndex!].textJson ??
                      '[{"insert":"\\n"}]';
                  print(a);
                  try {
                    var json = jsonDecode(a);
                    widget.controller.document = q.Document.fromJson(json);
                    widget.controller.moveCursorToEnd();
                  } catch (e) {
                    print('error$e');
                  }
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
