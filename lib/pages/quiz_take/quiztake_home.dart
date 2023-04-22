import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/pages/quiz_take/quiztake_take.dart';
import 'package:quizmaker/service/file_service.dart';

class QuizTakeHome extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const QuizTakeHome());
  }

  const QuizTakeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                FilePicker.platform.pickFiles(
                    allowedExtensions: ["qmzip"],
                    type: FileType.custom).then((value) async {
                  if (value == null) return;
                  var file = value.files.first;

                  // print(file.path);
                  final inputStream = InputFileStream(file.path!);
                  var decoder = ZipDecoder().decodeBuffer(inputStream);
                  var quizjsonfile =
                      decoder.files.firstWhere((a) => a.name == 'quiz.json');
                  var jsonString =
                      (const Utf8Decoder().convert(quizjsonfile.content));
                  var jsonmap = jsonDecode(jsonString);
                  var dir = join(await FileService().getQuizTakerProjectDir(),
                      jsonmap['quizTitle']);
                  await extractFileToDisk(file.path!, dir);
                  //to do:shuffle Question
                  var quizfile = File(join(dir, 'quiz.json'));

                  var jsonString2 = await quizfile.readAsString();
                  var jsonmap2 = jsonDecode(jsonString2);
                  var thestate = MakerLoaded.fromJson(jsonmap2);
                  List<Question> datalist = List.castFrom(thestate.datas);
                  datalist.shuffle();
                  await quizfile.writeAsString(
                      jsonEncode(thestate.copywith(datas: datalist).toJson()));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(Quiztake.route(dir));
                              },
                              child: const Text('Go Take Quiz!'))
                        ],
                        title: const Text('Alert'),
                        content: Column(
                          children: [
                            Text('Quiz title: ${jsonmap['quizTitle']}'),
                            for (var a in decoder.files) Text(a.name),
                          ],
                        ),
                      );
                    },
                  );
                });
              },
              child: const Text('Open ".qmzip" Quiz file'))),
    );
  }
}
