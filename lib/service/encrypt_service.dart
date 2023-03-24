import 'package:encrypt/encrypt.dart';

class EncryptService {
  final String uid = 'useremail';
  final String privatekey = 'CBoaDQIQAgceGg8dFAkMDBEOECEZCxgM';
  EncryptService();

  bool getAnswerBool(String id) {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final decrypted = encrypter.decrypt64(id, iv: iv);
    bool bools = decrypted.substring(decrypted.indexOf('#') + 1) == 'true'
        ? true
        : false;
    return bools;
  }

  int getAnswerIndex(String id) {
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final decrypted = encrypter.decrypt64(id, iv: iv);
    int index = int.parse(
      decrypted.substring(decrypted.indexOf('_') + 1, decrypted.indexOf('#')),
    );
    return index;
  }

  String setAnswerId(int index, String qId, bool istheAnswer) {
    String combined = '${qId}_$index#$istheAnswer';
    final key = Key.fromUtf8(privatekey);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(combined, iv: iv);
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
