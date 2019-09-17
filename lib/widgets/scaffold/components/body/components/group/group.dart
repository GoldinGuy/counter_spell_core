import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/sub_blocs/game/sub_game_blocs.dart/game_group.dart';
import 'package:sidereus/bloc/bloc_var.dart';

import 'player_tile.dart';

class BodyGroup extends StatelessWidget {
  final List<String> names;
  final int count;
  final double tileSize;
  final double coreTileSize;
  final CSGameGroup group;
  final CSTheme theme;
  
  const BodyGroup(this.names,{
    @required this.theme,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
  });
  
  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final actionBloc = bloc.game.gameAction;

    return BlocVar.build9(
      bloc.scaffold.mainIndex,
      bloc.scroller.isScrolling,
      bloc.scroller.intValue,
      actionBloc.selected,
      actionBloc.attackingPlayer,
      actionBloc.defendingPlayer,
      actionBloc.counterSet.variable,
      actionBloc.isCasting,
      bloc.game.gameState.gameState,
      builder: (
        BuildContext context, 
        int _, 
        bool isScrolling, 
        int increment,
        Map<String,bool> selected, 
        String attackingPlayer, 
        String defendingPlayer,
        Counter counter,
        bool isCasting,
        GameState gameState,
      ) {

        final page = bloc.scaffold.currentPage;

        return Material(
          elevation: 8,
          child: Column(children: <Widget>[
            for(final name in names)
              PlayerTile(
                name, 
                increment: increment,
                theme: theme,
                group: group,
                tileSize: tileSize,
                coreTileSize: coreTileSize,
                page: page,
                selectedNames: selected,
                whoIsAttacking: attackingPlayer,
                whoIsDefending: defendingPlayer,
                isScrollingSomewhere: isScrolling,
                counter: counter,
                casting: isCasting,
                gameState: gameState,
              ),
          ]),
        );

      },
    );
  }

}