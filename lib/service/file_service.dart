// class MakerService {
//   String fromJson() {}
//   List<Map> toJson() {}
// }
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quizmaker/bloc/maker_state.dart';

class FileService {
  FileService();
  Future<List<Map>> getListFoldersProject() async {
    var appDir = await getApplicationDocumentsDirectory();
    Directory projectDir = Directory(path.join(appDir.path, 'project'));
    // if (Platform.isWindows) {
    //   projectDir = Directory('${appDir.path}\\project\\');
    // } else if (Platform.isAndroid) {
    //   projectDir = Directory('${appDir.path}/project/');
    // }
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }
    List<FileSystemEntity> folder = Directory(projectDir.path).listSync();
    // print(folder);
    var result = folder
        .map((e) => {
              "basename": path.basename(e.path),
              "last_modified": e.statSync().modified
            })
        .toList();
    // print(folder[0].statSync().modified);
    return result;
  }

  Future<String> quizJsonFile(String folderName) async {
    var appDir = await getApplicationDocumentsDirectory();
    var projectFile =
        File(path.join(appDir.path, 'project', folderName, 'quiz.json'));
    // File('${appDir.path}\\project\\$folderName\\quiz.json');
    if (await projectFile.exists()) {
      return projectFile.readAsString();
    } else {
      throw Exception('File not Found');
    }
  }

  Future<Directory> createNewProjectDir(String title) async {
    var appDir = await getApplicationDocumentsDirectory();

    Directory projectDir = Directory(path.join(appDir.path, 'project', title));
    if (!await projectDir.exists()) {
      projectDir.create(recursive: true);
    }
    return projectDir;
  }

  Future<bool> saveToFile(MakerLoaded state) async {
    try {
      var appDir = await getApplicationDocumentsDirectory();

      var projectDir =
          Directory(path.join(appDir.path, 'project', state.quizTitle));
      // Directory('${appDir.path}\\project\\${state.quizTitle}\\');
      var file = File(path.join(projectDir.path, 'quiz.json'));
      // File('${projectDir.path}quiz.json');
      // print(file.path);
      await file.writeAsString(jsonEncode(state.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }
}
