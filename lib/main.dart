import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/maker_bloc.dart';
import 'package:quizmaker/mainapp.dart';
import 'package:quizmaker/service/file_service.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => MakerBloc(),
    child: MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        home: const HomePage()),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List> foldersProject = FileService().getListFoldersProject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('quizmaker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width / 6) + 8),
            child: Row(
              children: [
                Text(
                  'Folders : ',
                  textScaleFactor: 1.2,
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      setState(() {
                        foldersProject = FileService().getListFoldersProject();
                      });
                    },
                    icon: Icon(Icons.refresh))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 6),
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
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          // BlocProvider.of<MakerBloc>(context).add(event)
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              BlocProvider.of<MakerBloc>(context).add(
                                  InitiateFromFolder(
                                      folder: snapshot.data![i]));
                              return const MainApp();
                            },
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(i.toString()),
                            Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${snapshot.data![i]}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Text('Last Modified:')
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
          const Text('List of quiz project'),
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
                  FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ['qmzip']);
                },
                child: const Text('Import Created Quiz')),
          ),
        ],
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
