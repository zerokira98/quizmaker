import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/src/widgets/controller.dart';
import 'package:quizmaker/bloc/maker_bloc.dart';

class NavRail extends StatefulWidget {
  final QuillController controller;
  NavRail(this.controller, {super.key});

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  @override
  void initState() {
    super.initState();
  }

  bool extend = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MakerBloc, MakerState>(
      builder: (context, state) {
        if (state is MakerLoaded) {
          return NavigationRail(
              onDestinationSelected: (value) {
                if (value == state.datas.length) {
                  BlocProvider.of<MakerBloc>(context).add(AddQuestion());
                } else {
                  BlocProvider.of<MakerBloc>(context).add(GoToNumber(value));
                }
              },
              leading: InkWell(
                  onTap: () {
                    setState(() {
                      extend = !extend;
                    });
                  },
                  child: const Icon(Icons.menu)),
              extended: extend,
              destinations: [
                for (int i = 0; i < state.datas.length; i++)
                  NavigationRailDestination(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.album_outlined),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('$i'),
                        ],
                      ),
                      label: Container(
                        width: 200,
                        child: Text(
                          '${state.datas[i].text?.replaceAll('\n', ' ')}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                NavigationRailDestination(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        Padding(padding: EdgeInsets.all(2)),
                        // Text('[add new uestion]'),
                      ],
                    ),
                    label: Text('[add new question]')),
              ],
              selectedIndex: state.qSelectedIndex);
        }
        return SizedBox();
      },
    );
  }
}
