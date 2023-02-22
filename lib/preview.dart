import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quizmaker/bloc/maker_bloc.dart';
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
    widget.controller.addListener(() {
      // debugPrint(widget.controller.document.toDelta().toJson().toString());
      // setState(() {
      // text = widget.controller.document.toPlainText();
    });
    // });
    super.initState();
  }

  // Widget textViewBuilder(
  //   BuildContext context,
  //   q.Document document,
  // ) {
  //   List<TextSpan> a = document.toDelta().toJson().map((p0) {
  //     Color color = Colors.black;
  //     FontWeight weight = FontWeight.normal;
  //     double fontScale = 1.0;
  //     if (p0['attributes'] != null) {
  //       if (p0['attributes']['color'] != null) {
  //         String hexColor =
  //             p0['attributes']['color'].toString().replaceAll('#', '0xff');
  //         color = Color(int.parse(hexColor));
  //       }
  //       if (p0['attributes']['bold'] != null) {
  //         weight = p0['attributes']['bold'] == true
  //             ? FontWeight.bold
  //             : FontWeight.normal;
  //       }
  //       if (p0['attributes']['size'] != null) {
  //         switch (p0['attributes']['size']) {
  //           case 'large':
  //             fontScale = 1.2;
  //             break;
  //           case 'huge':
  //             fontScale = 1.5;
  //             break;
  //           default:
  //         }
  //         // fontScale = p0['attributes']['size'] == 'large' ? 18 : 14;
  //       }
  //     }
  //     return TextSpan(
  //         text: p0['insert'],
  //         style: TextStyle(
  //             color: color, fontWeight: weight, fontSize: 14 * fontScale));
  //   }).toList();
  //   // for (var ea in document.toDelta().toJson()) {
  //   //   print(ea);
  //   // }
  //   return RichText(
  //     text: TextSpan(children: a),
  //   );
  // }
  String htmlData(String jsonString) {
    if (jsonString.isEmpty) return '';
    List json = jsonDecode(jsonString);
    print('a$json');
    List<Map<String, dynamic>> yo =
        json.map<Map<String, dynamic>>((e) => e).toList();
    print('b$yo');

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
    print(telo.convert());
    return telo.convert();
  }

  @override
  Widget build(BuildContext context) {
    // print(htmlData);
    return Center(
      child: Column(
        children: [
          // Text('view $text'),
          Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
              ),
              child: BlocBuilder<MakerBloc, MakerState>(
                builder: (context, state) {
                  if (state is MakerLoaded) {
                    return Html(
                        data: htmlData(
                            state.datas[state.qSelectedIndex!].textJson ?? ''));
                  }
                  return Text('not loaded');
                },
              )),
          // Container(
          //     // color: Colors.red,
          //     child: textViewBuilder(context, widget.controller.document)),
        ],
      ),
    );
  }
}
