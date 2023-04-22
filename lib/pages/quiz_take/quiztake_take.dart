import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/taker/taker_bloc.dart';
import 'package:quizmaker/pages/quiz_take/cubit/navrail_cubit.dart';
import 'package:quizmaker/pages/quiz_take/quiztake_navrail.dart';
// import 'package:quizmaker/bloc/maker/maker_bloc.dart';
// import 'package:quizmaker/bloc/maker/maker_state.dart';
// import 'package:quizmaker/service/encrypt_service.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Quiztake extends StatefulWidget {
  final String dir;
  static Route<void> route(String dir) {
    return MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      TakerBloc()..add(TakerInitiate(path: dir)),
                ),
                BlocProvider(
                  create: (context) => NavrailCubit()..init(path: dir),
                ),
              ],
              child: Quiztake(dir),
            ));
  }

  const Quiztake(this.dir, {super.key});

  @override
  State<Quiztake> createState() => _QuiztakeState();
}

class _QuiztakeState extends State<Quiztake> {
  // final q.QuillController controller;
  final q.QuillController qc = q.QuillController.basic();
  // String text = "";

  String htmlData(String jsonString) {
    if (jsonString.isEmpty) return '';
    List json = jsonDecode(jsonString);
    List<Map<String, dynamic>> yo =
        json.map<Map<String, dynamic>>((e) => e).toList();

    // return '';
    // print(yo);
    var telo = QuillDeltaToHtmlConverter(
        (yo),
        ConverterOptions(
            converterOptions: OpConverterOptions(
                inlineStylesFlag: true,
                inlineStyles: InlineStyles({
                  'indent': InlineStyleType(fn: (value, op) {
                    final indentSize =
                        (double.tryParse(value) ?? double.nan) * 6;
                    final side =
                        op.attributes['direction'] == 'rtl' ? 'right' : 'left';
                    return 'padding-$side:${indentSize}px';
                  }),
                }))));
    telo.renderCustomWith = (DeltaInsertOp customOp, DeltaInsertOp? contextOp) {
      if (customOp.insert.type == 'custom') {
        var aew = jsonDecode(customOp.insert.value);
        // var aew = "https://a.ppy.sh/970470?1327276945.jpg";
        return '<img src="${aew['imgs']}" class="imgs">';
        // return '<img src="$aew">';
      } else {
        return 'Unmanaged custom blot!';
      }
    };
    // print(telo.convert());
    return telo.convert();
  }

  CustomRenderMatcher classAndIdMatcher({
    required String classToMatch,
  }) =>
      (context) =>
          context.tree.element!.attributes["class"] != null &&
          context.tree.element!.attributes["class"]!.contains(classToMatch);

  @override
  Widget build(BuildContext context) {
    // print(htmlData);
    return WillPopScope(
      onWillPop: () async {
        bool? a = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Caution!'),
              content: const Text(
                  'Any progress made will be lost. Proceed to exit?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Confirm')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel')),
              ],
            );
          },
        );
        return a ?? false;
      },
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          // leading: SizedBox(),
          title: const Text('Title'),
        ),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
          width: double.infinity,
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TakeNavRail(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        // padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(color: Colors.red),
                        // elevation: 1,
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        BlocBuilder<TakerBloc, TakerState>(
                                          builder: (context, state) {
                                            if (state is TakerState) {
                                              // return SizedBox();
                                              return InkWell(
                                                onTap: () {
                                                  // BlocProvider.of<TakerBloc>(context)
                                                  //     .add(GoToNumber(state.qSelectedIndex));
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 2),
                                                  ),
                                                  child: Html(
                                                    style: {
                                                      "body": Style(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          margin: Margins.zero),
                                                      "p": Style(
                                                          // padding: EdgeInsets.zero,
                                                          margin: Margins.zero),
                                                    },
                                                    data: htmlData(state
                                                            .quizdata!
                                                            .textJson ??
                                                        ''),
                                                    customRenders: {
                                                      classAndIdMatcher(
                                                              classToMatch:
                                                                  "imgs"):
                                                          CustomRender.widget(
                                                              widget:
                                                                  (p0, p1) =>
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
                                                                                  File(p0.tree.attributes["src"]!),
                                                                                  // height: 100,
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child: Image
                                                                            .file(
                                                                          File(p0
                                                                              .tree
                                                                              .attributes["src"]!),
                                                                          height:
                                                                              100,
                                                                        ),
                                                                      ))

                                                      // classAndIdRender(
                                                      //     classToMatch: "imgs", ctx: context)
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                            return const Text('not loaded');
                                          },
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.all(16)),

                                        BlocBuilder<TakerBloc, TakerState>(
                                          builder: (context, state) {
                                            if (state is TakerState) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: List.generate(
                                                          state.quizdata!
                                                              .answers.length,
                                                          (index) => Row(
                                                                children: [
                                                                  const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4)),
                                                                  Expanded(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        BlocProvider.of<TakerBloc>(context)
                                                                            .add(SelectAnswer(
                                                                          questionid: state
                                                                              .quizdata!
                                                                              .id,
                                                                          selectedid: state
                                                                              .quizdata!
                                                                              .answers[index]
                                                                              .id,
                                                                        ));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(8),
                                                                        margin: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                6),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          border: Border.all(
                                                                              width: state.selectedAnswer!.any((element) => element.selectedId == state.quizdata!.answers[index].id) ? 3 : 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('${index + 1}.'),
                                                                            const Padding(padding: EdgeInsets.all(4)),
                                                                            Expanded(
                                                                                child: Html(
                                                                              style: {
                                                                                "body": Style(padding: const EdgeInsets.all(0), margin: Margins.zero),
                                                                                "p": Style(padding: EdgeInsets.zero, margin: Margins.zero),
                                                                              },
                                                                              data: htmlData(state.quizdata!.answers[index].text ?? ''),
                                                                              customRenders: {
                                                                                classAndIdMatcher(classToMatch: "imgs"): CustomRender.widget(
                                                                                    widget: (p0, p1) => InkWell(
                                                                                          onTap: () {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return Dialog(
                                                                                                  child: Image.file(
                                                                                                    File(p0.tree.attributes["src"]!),
                                                                                                    // height: 100,
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                          child: Image.file(
                                                                                            File(p0.tree.attributes["src"]!),
                                                                                            height: 100,
                                                                                          ),
                                                                                        ))
                                                                              },
                                                                            )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4)),
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
                                        const Padding(
                                            padding: EdgeInsets.all(8)),

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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
