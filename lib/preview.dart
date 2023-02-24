import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/bloc/maker_state.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Preview extends StatefulWidget {
  final q.QuillController controller;
  const Preview(this.controller, {super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final q.QuillController qc = q.QuillController.basic();
  // String text = "";
  @override
  void initState() {
    widget.controller.addListener(() {});
    // });
    super.initState();
  }

  String htmlData(String jsonString) {
    if (jsonString.isEmpty) return '';
    List json = jsonDecode(jsonString);
    List<Map<String, dynamic>> yo =
        json.map<Map<String, dynamic>>((e) => e).toList();

    // return '';
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
                    return 'padding-$side:${indentSize}em';
                  }),
                }))));
    return telo.convert();
  }

  @override
  Widget build(BuildContext context) {
    // print(htmlData);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: SizedBox(),
        title: const Text('Live Preview'),
      ),
      body: Center(
        child: Column(
          children: [
            // Text('view $text'),
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                child: BlocBuilder<MakerBloc, MakerState>(
                  builder: (context, state) {
                    if (state is MakerLoaded) {
                      return Html(
                          data: htmlData(
                              state.datas[state.qSelectedIndex!].textJson ??
                                  ''));
                    }
                    return const Text('not loaded');
                  },
                )),
            const Padding(padding: EdgeInsets.all(8)),
            BlocBuilder<MakerBloc, MakerState>(
              builder: (context, state) {
                if (state is MakerLoaded) {
                  return Column(
                    children: List.generate(
                        state.datas[state.qSelectedIndex!].answers.length,
                        (index) => ListTile(
                              title: Text('$index'),
                            )),
                  );
                }
                return const SizedBox();
              },
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<MakerBloc>(context).add(AddAnswer());
                    },
                    child: Container(
                      // width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
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
            // Container(
            //     // color: Colors.red,
            //     child: textViewBuilder(context, widget.controller.document)),
          ],
        ),
      ),
    );
  }
}
