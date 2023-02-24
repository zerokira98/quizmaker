// class MakerService {
//   String fromJson() {}
//   List<Map> toJson() {}
// }
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quizmaker/bloc/maker_state.dart';

class FileService {
  FileService();
  Future<List> getListFoldersProject() async {
    var appDir = await getApplicationDocumentsDirectory();
    var projectDir = Directory('${appDir.path}\\project\\');
    List<FileSystemEntity> folder = Directory(projectDir.path).listSync();
    var result = folder.map((e) => path.basename(e.path)).toList();
    return result;
  }

  Future<String> quizJsonFile(String folderName) async {
    var appDir = await getApplicationDocumentsDirectory();
    var projectFile = File('${appDir.path}\\project\\$folderName\\quiz.json');
    if (await projectFile.exists()) {
      return projectFile.readAsString();
    } else {
      throw Exception('File not Found');
    }
  }

  Future<Directory> createNewProjectDir(String title) async {
    var appDir = await getApplicationDocumentsDirectory();
    if (!await Directory('${appDir.path}\\project\\$title\\').exists()) {
      await Directory('${appDir.path}\\project\\$title\\')
          .create(recursive: true);
    }
    var projectDir = Directory('${appDir.path}\\project\\$title\\');
    return projectDir;
  }

  Future<bool> saveToFile(MakerLoaded state) async {
    try {
      var appDir = await getApplicationDocumentsDirectory();
      var projectDir =
          Directory('${appDir.path}\\project\\${state.quizTitle}\\');
      var file = File('${projectDir.path}quiz.json');
      // print(file.path);
      await file.writeAsString(jsonEncode(state.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }
}
