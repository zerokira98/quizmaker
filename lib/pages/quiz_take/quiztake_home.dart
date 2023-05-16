import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
      appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                print('telo');
                FilePicker.platform
                    .pickFiles(
                        // allowedExtensions:
                        //     Platform.isWindows ? ["qmzip"] : null,
                        // type:
                        //     Platform.isWindows ? FileType.custom : FileType.any
                        )
                    .then((value) async {
                  if (value == null) return;
                  var file = value.files.first;

                  print("aa${file.bytes}");
                  final inputStream = InputFileStream(file.path!);
                  var decoder = ZipDecoder().decodeBuffer(inputStream);
                  var quizjsonfile =
                      decoder.files.firstWhere((a) => a.name == 'quiz.json');
                  var jsonString =
                      (const Utf8Decoder().convert(quizjsonfile.content));
                  var jsonmap = jsonDecode(jsonString);
                  var dir = p.join(await FileService().getQuizTakerProjectDir(),
                      jsonmap['quizTitle']);
                  await extractFileToDisk(file.path!, dir);
                  //to do:shuffle Question
                  var quizfile = File(p.join(dir, 'quiz.json'));

                  var jsonString2 = await quizfile.readAsString();
                  var jsonmap2 = jsonDecode(jsonString2);
                  var thestate = MakerLoaded.fromJson(jsonmap2);
                  // print(thestate.datas);
                  List<Question> newdatas = thestate.datas;
                  if (Platform.isAndroid) {
                    newdatas = thestate.datas.map((e) {
                      List telokntl = jsonDecode(e.textJson!);
                      List<Answer> newA = e.answers.map((e2) {
                        // print(e2.text);
                        // print('0');
                        if (e2.text! is! List) return e2;
                        List aText = jsonDecode(e2.text!);
                        aText = aText.map((e3) {
                          if (e3['insert'] is Map) {
                            String imgdir = jsonDecode(
                                (e3['insert'] as Map)['custom'])['imgs'];
                            var newimgdir = imgdir.substring(
                                imgdir.indexOf(jsonmap['quizTitle']));
                            newimgdir = (p.join(
                                dir.substring(
                                    0, dir.indexOf(jsonmap['quizTitle'])),
                                newimgdir));
                            var newmap = {
                              'insert': {
                                'custom':
                                    '{"imgs":"${(newimgdir.replaceAll('\\', '/'))}"}'
                              }
                            };
                            return newmap;
                          } else {
                            return e3;
                          }
                        }).toList();
                        return e2.copywith(text: jsonEncode(aText));
                      }).toList();
                      List newTextJson = telokntl.map((e2) {
                        if (e2['insert'] is Map) {
                          String imgdir = jsonDecode(
                              (e2['insert'] as Map)['custom'])['imgs'];
                          var newimgdir = imgdir
                              .substring(imgdir.indexOf(jsonmap['quizTitle']));
                          newimgdir = (p.join(
                              dir.substring(
                                  0, dir.indexOf(jsonmap['quizTitle'])),
                              newimgdir));
                          var newmap = {
                            'insert': {
                              'custom':
                                  '{"imgs":"${(newimgdir.replaceAll('\\', '/'))}"}'
                            }
                          };
                          return newmap;
                        } else {
                          return e2;
                        }
                      }).toList();
                      newA.shuffle();
                      return e.copywith(
                          textJson: jsonEncode(newTextJson), answers: newA);
                    }).toList();
                  }
                  // print(newdatas[2].textJson);
                  // List<Question> datalist = List.castFrom(newdatas);
                  newdatas = thestate.datas.map((e) {
                    List<Answer> newA = List.castFrom(e.answers);
                    newA.shuffle();
                    return e.copywith(answers: newA);
                  }).toList();
                  newdatas.shuffle();
                  await quizfile.writeAsString(
                      jsonEncode(thestate.copywith(datas: newdatas).toJson()));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .pushReplacement(Quiztake.route(dir));
                              },
                              child: const Text('Go Take Quiz!'))
                        ],
                        title: const Text('Alert'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text('Quiz title: ${jsonmap['quizTitle']}'),
                              for (var a in decoder.files) Text(a.name),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }, onError: (e) {
                  print("error$e");
                });
              },
              child: const Text('Open ".qmzip" Quiz file'))),
    );
  }
}
