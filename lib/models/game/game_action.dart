import 'package:counter_spell_new/models/game/game_actions/ga_composite.dart';

import 'model.dart';


export 'game_actions/actions.dart';


abstract class GameAction{

  //=============================
  // To be abstracted

  const GameAction();
  Map<String,PlayerAction> actions(Set<String> names);




  //=============================
  // Factory

  factory GameAction.fromPlayerActions(
    Map<String,PlayerAction> actions
  ){
    return GAComposite(actions);
  }




  //=============================
  // Actions

  void applyTo(GameState state){
    //LOW PRIORITY: aggiungi minval e maxval anche qui?? boh va pensata bene

    final Map<String, PlayerAction> _actions = this.actions(
      state.names
    );

    for(final entry in state.players.entries){
      entry.value.applyAction(
        _actions[entry.key]
      );
    }

  }

}


