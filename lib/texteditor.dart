import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/bloc/maker_state.dart';
import 'package:quizmaker/service/file_service.dart';
// import 'package:quizmaker/embed/image_embed.dart';
// import 'package:quizmaker/embed/toolbar/image_button.dart';

class TextEditor extends StatefulWidget {
  final q.QuillController controller;
  const TextEditor(this.controller, {super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  void initState() {
    var state = BlocProvider.of<MakerBloc>(context).state;
    if (state is MakerLoaded) {
      if (state.aSelectedIndex == null) {
        String a =
            state.datas[state.qSelectedIndex].textJson ?? '[{"insert":"\\n"}]';
        try {
          var json = jsonDecode(a);
          widget.controller.document = q.Document.fromJson(json);
          widget.controller.moveCursorToEnd();
        } catch (e) {
          debugPrint('error$e');
        }
      }
    }
    super.initState();
  }

  Future<void> _addEditNote(BuildContext context, {String? path}) async {
    final isEditing = path != null;
    String url = path ?? '';
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${isEditing ? 'Edit' : 'Add'} image'),
              IconButton(
                onPressed: () async {
                  var state = (BlocProvider.of<MakerBloc>(context).state
                      as MakerLoaded);
                  var a = await FilePicker.platform.pickFiles();
                  if (a != null) {
                    url = await FileService()
                        .savePictToProjectDir(a, state, pictpath: path);
                    setstate(() {});
                  }
                },
                icon: const Icon(Icons.camera_alt),
              )
            ],
          ),
          content: url.isEmpty ? const SizedBox() : Image.file(File(url)),
        );
      }),
    );

    if (url.isEmpty) return;

    // final block = q.BlockEmbed.image(url);
    final block = q.BlockEmbed.custom(
      ImageBlockEmbedy(url),
    );
    final controller = widget.controller;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          q.getEmbedNode(controller, controller.selection.start).item1;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }

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
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(content),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              Expanded(child: Container()),
              ElevatedButton.icon(
                  onPressed: () {
                    var state = (BlocProvider.of<MakerBloc>(context).state
                        as MakerLoaded);
                    BlocProvider.of<MakerBloc>(context)
                        .add(DeleteQuestion(state.qSelectedIndex));
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Question'))
            ],
          ),
          q.QuillToolbar.basic(
            customButtons: [
              q.QuillCustomButton(
                  icon: Icons.image,
                  onTap: () {
                    _addEditNote(context);
                  }),
            ],
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
              child: q.QuillEditor.basic(
            embedBuilders: [
              ImageEmbedBuildery(addEditNote: _addEditNote),
            ],
            controller: widget.controller,
            readOnly: false, // true for view only mode
          ))
        ]));
  }
}

class ImageBlockEmbedy extends q.CustomBlockEmbed {
  const ImageBlockEmbedy(String value) : super(noteType, value);

  static const String noteType = 'imgs';

  // static ImageBlockEmbedy fromDocument(q.Document document) =>
  //     ImageBlockEmbedy(jsonEncode(document.toDelta().toJson()));

  q.Document get document => q.Document.fromJson(jsonDecode(data));
}

class ImageEmbedBuildery implements q.EmbedBuilder {
  ImageEmbedBuildery({required this.addEditNote});

  Future<void> Function(BuildContext context, {String? path}) addEditNote;

  @override
  String get key => 'imgs';

  @override
  Widget build(
    BuildContext context,
    q.QuillController controller,
    q.Embed node,
    bool readOnly,
  ) {
    final path = (node.value.data);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Image.file(
          File(path),
          height: 100,
        ),
        // leading: const Icon(Icons.notes),
        onTap: () => addEditNote(context, path: path),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
