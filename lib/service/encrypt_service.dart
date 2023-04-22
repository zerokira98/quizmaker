import 'dart:math';

import 'package:encrypt/encrypt.dart';

class EncryptService {
  final String uid = 'useremail';
  final String privatekey = 'CBoaDQIQAgceGg8dFAkMDBEOECEZCxgM';
  EncryptService();

  bool getAnswerBool(String id) {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(4);
    final decrypted = encrypter.decrypt64(id, iv: iv);
    bool bools = decrypted.substring(
                decrypted.indexOf('#') + 1, decrypted.indexOf('?')) ==
            't'
        ? true
        : false;
    return bools;
  }

  int getAnswerIndex(String id) {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(4);
    final decrypted = encrypter.decrypt64(id, iv: iv);
    int index = int.parse(
      decrypted.substring(decrypted.indexOf('_') + 1, decrypted.indexOf('#')),
    );
    return index;
  }

  String setAnswerId(int index, String qId, bool istheAnswer) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    var rand = getRandomString(10);
    String isAnswer = istheAnswer ? 't' : 'f';
    String combined = '${qId}_$index#$isAnswer?$rand';
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(4);
    final encrypted = encrypter.encrypt(combined, iv: iv);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  Future<int> getQuestionIndexfromId(String id) async {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final decrypted = encrypter.decrypt64(id, iv: iv);
    var idnumber = int.parse(decrypted.substring(decrypted.indexOf('_') + 1));
    return idnumber;
  }

  Future<String> questionIdfromIndex(String titleandId) async {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(titleandId, iv: iv);
    return encrypted.base64;
  }
}
