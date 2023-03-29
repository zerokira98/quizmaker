import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_bloc.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/file_service.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            // useRootNavigator: false,
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: GestureDetector(
                    onTap: () {},
                    child: Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Settings',
                            textScaleFactor: 1.5,
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  var boolpr =
                                      (BlocProvider.of<MakerBloc>(context).state
                                              as MakerLoaded)
                                          .valdi();
                                  if (boolpr) {
                                    FileService().createZip(
                                        BlocProvider.of<MakerBloc>(context)
                                            .state as MakerLoaded);
                                  } else {
                                    print(boolpr);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'There\'s empty correct answer')));
                                  }
                                },
                                child: const Text('Export QuizData')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close')),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.settings),
        label: const Text('Settings'));
  }
}
