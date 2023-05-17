import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path/path.dart';
import 'package:quizmaker/bloc/maker/maker_bloc.dart';
import 'package:quizmaker/pages/quiz_creator/mainapp.dart';
import 'package:quizmaker/service/file_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePageCreate extends StatefulWidget {
  const HomePageCreate({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePageCreate());
  }

  @override
  State<HomePageCreate> createState() => _HomePageCreateState();
}

class _HomePageCreateState extends State<HomePageCreate> {
  Future<List<Map>> foldersProject = FileService().getListFoldersProject();

  void asyncButton(BuildContext context) {
    // if (Platform.isAndroid) {
    //   FilePicker.platform.pickFiles().then((value) async {
    //     if (value == null) return null;
    //   });
    // }
    if (!Platform.isWindows) {
      FilePicker.platform
          .pickFiles(
        type: Platform.isWindows ? FileType.custom : FileType.any,
        allowedExtensions: Platform.isWindows ? ['qmzip'] : null,
      )
          .then((value) async {
        if (value == null) return null;

        // return null;
        var file = value.files.first;
        if (!file.name.contains('qmzip')) return null;
        // print(file.path);
        final inputStream = InputFileStream(file.path!);
        var decoder = ZipDecoder().decodeBuffer(inputStream);
        var quizjsonfile =
            decoder.files.firstWhere((a) => a.name == 'quiz.json');
        var jsonString = (const Utf8Decoder().convert(quizjsonfile.content));
        var jsonmap = jsonDecode(jsonString);
        List<Map> folders = await foldersProject;
        // print(folders);
        // print(jsonmap['quizTitle']);
        for (var element in folders) {
          if (element.containsValue(jsonmap['quizTitle'])) {
            // print('Exist');
            return {
              "success": false,
              "title": jsonmap['quizTitle'],
              "e": "Project with same name exist.",
              "path": file.path
            };
            // break;
          }
        }
        return {
          "success": true,
          "path": file.path,
          "title": jsonmap['quizTitle'],
        };
      }).then((value) {
        if (value != null) {
          if ((value['success'] as bool)) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                BlocProvider.of<MakerBloc>(context).add(InitiateFromZip(
                    zippath: value['path'] as String, title: value['title']));
                return const MainApp();
              },
            ));
          }
          if (!(value['success'] as bool)) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Caution'),
                  content: Text('${value['e'] as String} Replace it?'),
                  actions: [
                    TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              BlocProvider.of<MakerBloc>(context).add(
                                  InitiateFromZip(
                                      zippath: value['path'] as String,
                                      title: value['title']));
                              return const MainApp();
                            },
                          ));
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                );
              },
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width / 6) + 8),
                child: Row(
                  children: [
                    const Text(
                      'Folders : ',
                      textScaleFactor: 1.2,
                    ),
                    Expanded(child: Container()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            foldersProject =
                                FileService().getListFoldersProject();
                          });
                        },
                        icon: const Icon(Icons.refresh))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width /
                        (Platform.isWindows ? 6 : 12)),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8.0)),
                // alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.45,
                child: FutureBuilder(
                  future: foldersProject,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print('hei');
                      // print(snapshot.data);
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('Empty'));
                      }
                      return ListView.builder(
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              // BlocProvider.of<MakerBloc>(context).add(event)
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  BlocProvider.of<MakerBloc>(context).add(
                                      InitiateFromFolder(
                                          folder: snapshot.data![i]
                                              ["basename"]));
                                  return const MainApp();
                                },
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('$i.'),
                                Expanded(
                                  flex: 2,
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${snapshot.data![i]["basename"]}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                    'Last Modified : ${snapshot.data![i]["last_modified"].toString().substring(0, snapshot.data![i]["last_modified"].toString().length - 4)}'),
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: (MediaQuery.of(context).size.width / 6) + 8),
                child: Row(
                  children: [
                    const Text('List of quiz project'),
                    Expanded(child: Container()),
                    ElevatedButton(
                        onPressed: () async {
                          var a = await FileService().getQuizMakerProjectDir();
                          launchUrlString('file://$a');
                        },
                        child: const Text('Open Quiz Project Folder')),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InitiateNewQuiz()));
                    },
                    child: const Text('Create new Quiz')),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      asyncButton(context);
                    },
                    child: const Text('Import Created Quiz')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InitiateNewQuiz extends StatelessWidget {
  InitiateNewQuiz({super.key});
  final TextEditingController titleController = TextEditingController();
  finishCallback(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        BlocProvider.of<MakerBloc>(context)
            .add(Initialize(title: titleController.text));
        return const MainApp();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Quiz Baru'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      if (value.length == 2) {
                        titleController.text =
                            value[0].toUpperCase() + value[1];
                        titleController.selection = TextSelection.collapsed(
                            offset: titleController.text.length);
                      }
                    },
                    onSubmitted: (value) {
                      finishCallback(context);
                    },
                    controller: titleController,
                    decoration:
                        const InputDecoration(label: Text('Judul Quiz')),
                  )),
                ],
              ),
              const Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                  onPressed: () {
                    finishCallback(context);
                  },
                  child: const Text('Buat'))
            ],
          ),
        ),
      ),
    );
  }
}
