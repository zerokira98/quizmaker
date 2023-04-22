import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/taker/taker_bloc.dart';
import 'package:quizmaker/pages/quiz_take/cubit/navrail_cubit.dart';

class TakeNavRail extends StatefulWidget {
  // final q.QuillController controller;
  const TakeNavRail({super.key});

  @override
  State<TakeNavRail> createState() => _TakeNavRailState();
}

class _TakeNavRailState extends State<TakeNavRail> {
  @override
  void initState() {
    super.initState();
  }

  // List destination(TakerState state) {
  //   if (state.maxQuestion < 1) ;
  //   return [];
  // }

  bool extend = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavrailCubit, NavrailState>(
      // buildWhen: (previous, current) => previous.maxQuestion == 0,
      builder: (context, state) {
        // print('maxq${state.maxQuestion}');
        return Container(
          // width: 100,
          // height: double.infinity,
          // alignment: Alignment.center,
          decoration:
              BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          // child: Text('telo'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                state.titles.length,
                (index) => IconButton(
                      // isSelected: true,
                      color: index == state.selectedIndex
                          ? Colors.red
                          : Colors.grey,
                      icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${index + 1}'),
                            const Icon(Icons.radio_button_on),
                            Text(
                              (state.titles[index]
                                  .trim()
                                  .replaceAll("\uFFFC", "[img]")
                                  .replaceAll('\n', ' ')),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                      onPressed: () {
                        BlocProvider.of<TakerBloc>(context)
                            .add(GotoQuestion(index: index));
                        BlocProvider.of<NavrailCubit>(context)
                            .selectindex(index);
                      },
                    )),
          ),
        );
      },
    );
  }
}
