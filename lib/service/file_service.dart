// class MakerService {
//   String fromJson() {}
//   List<Map> toJson() {}
// }
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/encrypt_service.dart';

class FileService {
  FileService();
  Future<List<Map>> getListFoldersProject() async {
    var appDir = await getQuizMakerProjectDir();
    Directory projectDir = Directory(path.join(appDir));
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
    var appDir = await getQuizMakerProjectDir();
    var projectFile = File(path.join(appDir, folderName, 'quiz.json'));
    if (await projectFile.exists()) {
      return projectFile.readAsString();
    } else {
      throw Exception('File not Found');
    }
  }

  Future<String> takerJsonFile(String folderName) async {
    var appDir = await getQuizTakerProjectDir();
    var projectFile = File(path.join(appDir, folderName, 'quiz.json'));
    if (await projectFile.exists()) {
      return projectFile.readAsString();
    } else {
      throw Exception('File not Found');
    }
  }

  Future<Directory> createNewProjectDir(String title) async {
    var appDir = await getQuizMakerProjectDir();

    Directory projectDir = Directory(path.join(appDir, title));
    if (!await projectDir.exists()) {
      projectDir.create(recursive: true);
      var file = File(path.join(projectDir.path, 'quiz.json'));
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
    }
    return projectDir;
  }

  Future<bool> saveToFile(MakerLoaded state) async {
    try {
      var appDir = await getQuizMakerProjectDir();

      var projectDir = Directory(path.join(appDir, state.quizTitle));
      // Directory('${appDir.path}\\project\\${state.quizTitle}\\');
      var file = File(path.join(projectDir.path, 'quiz.json'));
      // (file.exists());
      await file.writeAsString(jsonEncode(state.toJson()));
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<String> savePictToProjectDir(
      FilePickerResult pickedfile, MakerLoaded state,
      {String? pictpath}) async {
    String url;

    var appDir = await getQuizMakerProjectDir();

    var projectDir = Directory(path.join(appDir, state.quizTitle, 'resimg'));
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }
    var selectedFile = File(pickedfile.files.first.path!);
    var file = File(path.join(
      projectDir.path,
      (await EncryptService().questionIdfromIndex(pickedfile.paths[0]!))
              .replaceAll(RegExp(r'[<>:"\/\\|?*]'), '') +
          path.extension(pickedfile.names.first!),
    ));
    if (await file.exists()) {
      return file.path;
    }
    if (pictpath != null) {
      if (pictpath == file.path) {
        return pictpath;
      }
    }
    url = file.path;
    await file.writeAsBytes(await selectedFile.readAsBytes());
    return url;
  }

  Future<String> getQuizMakerProjectDir() async {
    var appDir = await getApplicationDocumentsDirectory();
    Directory projectDir = Directory(path.join(appDir.path, 'quizmaker'));
    return projectDir.path;
  }

  Future<String> getQuizTakerProjectDir() async {
    var appDir = await getApplicationDocumentsDirectory();
    Directory projectDir = Directory(path.join(appDir.path, 'quiztaker'));
    return projectDir.path;
  }

  Future createZip(MakerLoaded state) async {
    var appDir = await getQuizMakerProjectDir();
    String? savedir;
    if (Platform.isWindows) {
      savedir = await FilePicker.platform.saveFile(
          initialDirectory: appDir,
          fileName: '${state.quizTitle}.qmzip',
          type: FileType.custom,
          allowedExtensions: ['qmzip'],
          dialogTitle: 'Save to');
    }
    if (Platform.isAndroid) {
      //TO DO: PLZ
      // final params = SaveFileDialogParams(
      //   fileName: '${state.quizTitle}.qmzip',
      // );
      // savedir = await FlutterFileDialog.saveFile(params: params);
      // print(savedir);
    }
    if (savedir != null) {
      // print('$savedir.qmzip');
      try {
        // print(projectDir.path);
        final zipFile = File(savedir);

        var projectDir = await Directory(path.join(
          appDir,
          state.quizTitle,
        )).create();

        var encoder = ZipFileEncoder();
        encoder.create(zipFile.path);
        await encoder.addDirectory(projectDir, includeDirName: false);
        encoder.close();
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  // Future openZip(String zipPath) async {
  //   final appdir = await getApplicationDocumentsDirectory();
  //   final dir = Directory(path.join(appdir.path, 'quiztaker'));
  //   var zipFile = await File(zipPath).readAsBytes();
  //   final archive = ZipDecoder().decodeBytes(zipFile);
  //   for (var e in archive) {
  //     var filename = e.name;
  //     if (e.isFile) {
  //       var data = e.content;
  //       File(path.join(dir.path, filename))
  //         ..createSync(recursive: true)
  //         ..writeAsBytesSync(data);
  //     } else {
  //       Directory(path.join(dir.path, filename)).create(recursive: true);
  //     }
  //   }
  // }
}
