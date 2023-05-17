import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizmaker/bloc/taker/taker_bloc.dart';
import 'package:quizmaker/bloc/taker/taker_state.dart';
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
  Widget listMode(BuildContext context, NavrailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
          state.titles.length,
          (index) => InkWell(
                // isSelected: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: state.selectedIndex == index
                        ? Colors.black12
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${index + 1}'),
                        BlocBuilder<TakerBloc, TakerState>(
                          builder: (context, state2) {
                            return Icon(
                              Icons.radio_button_on,
                              color: state2.selectedAnswer![index].selectedId !=
                                      null
                                  ? Colors.green
                                  : Colors.red,
                            );
                          },
                        ),
                        if (state.expanded)
                          Expanded(
                            child: Text(
                              (state.titles[index]
                                  .trim()
                                  .replaceAll("\uFFFC", "[img]")
                                  .replaceAll('\n', ' ')),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ]),
                ),
                onTap: () {
                  BlocProvider.of<TakerBloc>(context)
                      .add(GotoQuestion(index: index));
                  BlocProvider.of<NavrailCubit>(context).selectindex(index);
                },
              )),
    );
    // return SizedBox();
  }

  Widget gridmode(BuildContext context, NavrailState state) {
    return GridView.count(
      crossAxisCount: state.expanded ? 4 : 1,
      children: List.generate(
          state.titles.length,
          (index) => InkWell(
                // isSelected: true,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: index == state.selectedIndex
                        ? Border.all(color: Theme.of(context).primaryColorLight)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // elevation: index == state.selectedIndex ? 4 : 1,
                  // shadowColor:
                  //     index == state.selectedIndex ? Colors.white : Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${index + 1}'),
                          BlocBuilder<TakerBloc, TakerState>(
                            builder: (context, state2) {
                              return Container(
                                height: 10,
                                width: 20,
                                color:
                                    state2.selectedAnswer![index].selectedId !=
                                            null
                                        ? Colors.green
                                        : Colors.red,
                              );
                            },
                          )
                        ]),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<TakerBloc>(context)
                      .add(GotoQuestion(index: index));
                  BlocProvider.of<NavrailCubit>(context).selectindex(index);
                },
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavrailCubit, NavrailState>(
      // buildWhen: (previous, current) => previous.maxQuestion == 0,
      builder: (context, state) {
        // print('maxq${state.maxQuestion}');
        return AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 240),
          width: state.expanded ? 250 : 55,
          padding: const EdgeInsets.all(4.0),
          decoration:
              BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          // child: Text('telo'),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(6),
                    // height: 40,
                    // color: Colors.green,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<NavrailCubit>(context)
                                  .changeviewmode();
                            },
                            child: Icon(state.viewmode == RailViewMode.list
                                ? Icons.grid_view_sharp
                                : Icons.view_list),
                          ),
                          if (state.expanded) Expanded(child: Container()),
                          if (state.expanded)
                            InkWell(
                                onTap: () {
                                  BlocProvider.of<NavrailCubit>(context)
                                      .expand();
                                },
                                child: const Icon(
                                    Icons.arrow_circle_left_outlined))
                        ]),
                  )),
                ],
              ),
              if (!state.expanded)
                InkWell(
                    onTap: () {
                      BlocProvider.of<NavrailCubit>(context).expand();
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined)),
              const Padding(padding: EdgeInsets.all(4)),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(-1, 0), end: const Offset(0, 0))
                        .animate(CurvedAnimation(
                            parent: animation, curve: Curves.easeOutQuad)),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  child: state.viewmode == RailViewMode.grid
                      ? gridmode(context, state)
                      : listMode(context, state),
                ),
              ),
              // child: state.viewmode == RailViewMode.grid
              //     ? gridmode(context, state)
              //     : listMode(context, state)),
            ],
          ),
        );
      },
    );
  }
}
