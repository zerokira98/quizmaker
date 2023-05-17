import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker/maker_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/encrypt_service.dart';
import 'package:quizmaker/service/htmlparser.dart';

class Preview extends StatefulWidget {
  final q.QuillController controller;
  const Preview(this.controller, {super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final q.QuillController qc = q.QuillController.basic();
  bool editingview = true;
  // String text = "";
  @override
  void initState() {
    widget.controller.addListener(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(htmlData);
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Card(
        elevation: 7,
        child: Scaffold(
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // leading: SizedBox(),
            title: const Text('kinda Live Preview'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      editingview = !editingview;
                    });
                  },
                  icon: Icon(
                      editingview ? Icons.visibility : Icons.visibility_off))
            ],
          ),
          body: Card(
            // elevation: 1,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text('view $text'),
                          BlocBuilder<MakerBloc, MakerState>(
                            builder: (context, state) {
                              if (state is MakerLoaded) {
                                return InkWell(
                                  onTap: () {
                                    BlocProvider.of<MakerBloc>(context)
                                        .add(GoToNumber(state.qSelectedIndex));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                          color: state.aSelectedIndex == null
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          width: 2),
                                    ),
                                    child: Html(
                                      style: {
                                        "body": Style(
                                            padding: const EdgeInsets.all(0),
                                            margin: Margins.zero),
                                        "p": Style(
                                            // padding: EdgeInsets.zero,
                                            margin: Margins.zero),
                                      },
                                      data: HtmlParsequill().htmlData(state
                                              .datas[state.qSelectedIndex]
                                              .textJson ??
                                          ''),
                                      extensions: [
                                        TagExtension(
                                          tagsToExtend: {'img'},
                                          builder: (p0) {
                                            return InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Image.file(
                                                        File(p0.attributes[
                                                            "src"]!),
                                                        // height: 100,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.file(
                                                File(p0.attributes["src"]!),
                                                height: 100,
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const Text('not loaded');
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(16)),
                          editingview
                              ? BlocBuilder<MakerBloc, MakerState>(
                                  builder: (context, state) {
                                    if (state is MakerLoaded &&
                                        state.datas[state.qSelectedIndex]
                                            .answers.isNotEmpty) {
                                      return Row(
                                        children: [
                                          const Text('correct\nanswer'),
                                          Expanded(child: Container()),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                )
                              : const SizedBox(),
                          BlocBuilder<MakerBloc, MakerState>(
                            builder: (context, state) {
                              if (state is MakerLoaded) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: List.generate(
                                            state.datas[state.qSelectedIndex]
                                                .answers.length,
                                            (index) => Row(
                                                  children: [
                                                    editingview
                                                        ? IconButton(
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                          MakerBloc>(
                                                                      context)
                                                                  .add(SetRightAnswer(
                                                                      index:
                                                                          index));
                                                            },
                                                            icon: Icon(
                                                              EncryptService().getAnswerBool(state
                                                                      .datas[state
                                                                          .qSelectedIndex]
                                                                      .answers[
                                                                          index]
                                                                      .id)
                                                                  ? Icons
                                                                      .radio_button_on_outlined
                                                                  : Icons
                                                                      .radio_button_off_outlined,
                                                              color: Colors
                                                                  .green[800],
                                                            ))
                                                        : const SizedBox(),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(4)),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      MakerBloc>(
                                                                  context)
                                                              .add(SelectAnswer(
                                                                  index));
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(
                                                              state.aSelectedIndex ==
                                                                      index
                                                                  ? 12
                                                                  : 8),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              border: Border.all(
                                                                  width:
                                                                      state.aSelectedIndex ==
                                                                              index
                                                                          ? 3
                                                                          : 1,
                                                                  color: state
                                                                              .aSelectedIndex ==
                                                                          index
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Colors
                                                                          .grey)),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${index + 1}.'),
                                                              const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4)),
                                                              Expanded(
                                                                  child: Html(
                                                                style: {
                                                                  "body": Style(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              0),
                                                                      margin: Margins
                                                                          .zero),
                                                                  "p": Style(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      margin: Margins
                                                                          .zero),
                                                                },
                                                                data: HtmlParsequill().htmlData(state
                                                                        .datas[state
                                                                            .qSelectedIndex]
                                                                        .answers[
                                                                            index]
                                                                        .text ??
                                                                    ''),
                                                                extensions: [
                                                                  TagExtension(
                                                                    tagsToExtend: {
                                                                      "img"
                                                                    },
                                                                    builder: (p0) =>
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Dialog(
                                                                              child: Image.file(
                                                                                File(p0.attributes["src"]!),
                                                                                // height: 100,
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: Image
                                                                          .file(
                                                                        File(p0.attributes[
                                                                            "src"]!),
                                                                        height:
                                                                            100,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    editingview
                                                        ? InkWell(
                                                            onTap: () {
                                                              BlocProvider.of<
                                                                          MakerBloc>(
                                                                      context)
                                                                  .add(DeleteAnswer(
                                                                      index:
                                                                          index));
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ))
                                                        : const SizedBox(),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(4)),
                                                  ],
                                                )),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          editingview
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<MakerBloc>(context)
                                              .add(AddAnswer());
                                        },
                                        child: Container(
                                          // width: double.infinity,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2),
                                          ),
                                          child: const Text(
                                            'Tambah Jawaban +',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox()
                          // Container(
                          //     // color: Colors.red,
                          //     child: textViewBuilder(context, widget.controller.document)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
