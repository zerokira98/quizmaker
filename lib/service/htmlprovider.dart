import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class HtmlProvider {
  HtmlProvider();
  static Map<String, Style> style = {
    "body": Style(padding: const EdgeInsets.all(0), margin: Margins.zero),
    "p": Style(margin: Margins.zero),
  };
  static HtmlProvider get instance => HtmlProvider();
  static Widget imageView(ExtensionContext p0, BuildContext context) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: PhotoView(
                  imageProvider: FileImage(
                    File(p0.attributes["src"]!),
                  ),
                ),
              );
            },
          );
        },
        child: Image.file(
          File(p0.attributes["src"]!),
          height: 125,
        ),
      );
  static String htmlData(String jsonString) {
    if (jsonString.isEmpty) return '';
    List json = jsonDecode(jsonString);
    List<Map<String, dynamic>> yo =
        json.map<Map<String, dynamic>>((e) => e).toList();

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
        return '<img src="${aew['imgs']}" class="imgs">';
      } else {
        return 'Unmanaged custom blot!';
      }
    };
    // print(telo.convert());
    return telo.convert();
  }
}
