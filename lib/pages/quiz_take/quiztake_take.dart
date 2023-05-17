import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/auth/auth_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/bloc/taker/taker_bloc.dart';
import 'package:quizmaker/bloc/taker/taker_state.dart';
import 'package:quizmaker/pages/quiz_take/cubit/navrail_cubit.dart';
import 'package:quizmaker/pages/quiz_take/quiztake_navrail.dart';
import 'package:path/path.dart' as p;
import 'package:quizmaker/service/file_service.dart';
import 'package:quizmaker/service/htmlparser.dart';

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
  final q.QuillController qc = q.QuillController.basic();

  Widget answerWidget() => BlocBuilder<TakerBloc, TakerState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: List.generate(
                      state.quizdata!.answers.length,
                      (index) => Row(
                            children: [
                              const Padding(padding: EdgeInsets.all(4)),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<TakerBloc>(context)
                                        .add(SelectAnswer(
                                      questionid: state.quizdata!.id,
                                      selectedid:
                                          state.quizdata!.answers[index].id,
                                    ));
                                    BlocProvider.of<NavrailCubit>(context)
                                        .setAnswered(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: state.selectedAnswer!.any(
                                                (element) =>
                                                    element.selectedId ==
                                                    state.quizdata!
                                                        .answers[index].id)
                                            ? 3
                                            : 1,
                                        color: state.selectedAnswer!.any(
                                                (element) =>
                                                    element.selectedId ==
                                                    state.quizdata!
                                                        .answers[index].id)
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withGreen(240)
                                            : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${index + 1}.'),
                                        const Padding(
                                            padding: EdgeInsets.all(4)),
                                        Expanded(
                                            child: Html(
                                          style: {
                                            "body": Style(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin: Margins.zero),
                                            "p": Style(
                                                padding: EdgeInsets.zero,
                                                margin: Margins.zero),
                                          },
                                          data: HtmlParsequill().htmlData(state
                                                  .quizdata!
                                                  .answers[index]
                                                  .text ??
                                              ''),
                                          extensions: [
                                            TagExtension(
                                              tagsToExtend: {'img'},
                                              builder: (p0) => HtmlParsequill()
                                                  .imageView(p0, context),
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(4)),
                            ],
                          )),
                ),
              ),
            ],
          );
        },
      );
  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () {
                  var pri =
                      BlocProvider.of<TakerBloc>(context).state.selectedAnswer;
                  bool validation = pri!.every(
                    (element) => element.selectedId != null,
                  );
                  var expo = pri.map(
                    (e) {
                      return e.toJson();
                    },
                  ).toList();
                  String answerData = jsonEncode(expo);

                  var a = FileService()
                      .takerJsonFile(p.basename(
                          BlocProvider.of<TakerBloc>(context).state.path))
                      .then((value) {
                    var b = jsonDecode(value);
                    var c = MakerLoaded.fromJson(b);
                    Map answerfileData = {
                      "quizTitle": c.quizTitle,
                      'makerid': c.makerUid,
                      'takerid':
                          BlocProvider.of<AuthBloc>(context).state.user.id,
                      'answerData': answerData
                    };
                    print(answerfileData);
                  });

                  print(validation);
                },
                child: const Text('Export'))
          ],
          title: Text(
            p.basename(BlocProvider.of<TakerBloc>(context).state.path),
            style: const TextStyle(color: Colors.black),
          ),
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
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        BlocBuilder<TakerBloc, TakerState>(
                                          builder: (context, state) {
                                            return InkWell(
                                              onTap: () {},
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
                                                        margin: Margins.zero),
                                                  },
                                                  data: HtmlParsequill()
                                                      .htmlData(state.quizdata!
                                                              .textJson ??
                                                          ''),
                                                  extensions: [
                                                    TagExtension(
                                                      tagsToExtend: {'img'},
                                                      builder: (p0) =>
                                                          HtmlParsequill()
                                                              .imageView(
                                                                  p0, context),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.all(16)),
                                        answerWidget(),
                                        const Padding(
                                            padding: EdgeInsets.all(8)),
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
