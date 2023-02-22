import 'package:bloc/bloc.dart';
import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'maker_event.dart';
part 'maker_state.dart';

class MakerBloc extends Bloc<MakerEvent, MakerState> {
  MakerBloc() : super(MakerInitial()) {
    on<Initialize>(_initialize);
    on<GoToNumber>(_goToNumber);
    on<AddQuestion>(_addQuestion);
    on<UpdateQuestion>(_updateQuestion);
  }

  _updateQuestion(UpdateQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var updatedQuestion = theState.datas[theState.qSelectedIndex!]
        .copywith(event.stringPlain, event.stringJson, null);
    var selectedId = theState.datas[theState.qSelectedIndex!].id;
    var newdatas = theState.datas
        .map((e) => e.id == selectedId ? updatedQuestion : e)
        .toList();
    print('here');
    emit(theState.copywith(datas: newdatas));
  }

  _initialize(Initialize event, Emitter<MakerState> emit) async {
    final title = event.title + '_0';
    final key = Key.fromUtf8('CBoaDQIQAgceGg8dFAkMDBEOECEZCxgM');

    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);

    final encrypted = encrypter.encrypt(title, iv: iv);
    final decrypted = encrypter.decrypt64(encrypted.base64, iv: iv);
    var questData = Question(encrypted.base64, [], null, null, null, null);
    print(encrypted.base64);
    print(decrypted);
    emit(MakerLoaded(
        quizTitle: event.title, qDatas: [questData], qSelectedIndex: 0));
  }

  _goToNumber(GoToNumber event, Emitter<MakerState> emit) async {
    if (state is MakerLoaded) {
      emit((state as MakerLoaded).copywith(qSelectedIndex: event.number));
    }
  }

  _addQuestion(AddQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var prevdata = (state as MakerLoaded).datas;
    final iv = IV.fromLength(16);
    final key = Key.fromUtf8('CBoaDQIQAgceGg8dFAkMDBEOECEZCxgM');
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(prevdata.last.id, iv: iv);
    var idnumber = int.parse(decrypted.substring(decrypted.indexOf('_') + 1));
    var id = '${theState.quizTitle}_${idnumber + 1}';
    final encrypted = encrypter.encrypt(id, iv: iv);
    var newQuestion = Question(encrypted.base64, [], null, null, null, null);
    var newDatas = prevdata + [newQuestion];
    emit(MakerLoaded(
        quizTitle: theState.quizTitle,
        qSelectedIndex: prevdata.length,
        qDatas: newDatas));
  }
}
