import 'package:counter_spell_new/models/game/model.dart';
import 'package:sidereus/sidereus.dart';

import '../game.dart';

class CSGameState {

  void dispose(){
    this.gameState.dispose();
    this.futureActions.dispose();
  }

  //====================================
  // Values

  final PersistentVar<GameState> gameState;
  final BlocVar<List<GameAction>> futureActions;

  final CSGame parent;



  //====================================
  // Getters

  bool get forwardable => futureActions.value.isNotEmpty;
  bool get backable => gameState.value.historyLenght > 1;


  //====================================
  // Constructor
  CSGameState(this.parent): 
    gameState = PersistentVar<GameState>(
      key: "bloc_game_state_blocvar_gamestate",
      initVal: GameState.start(_kNames, startingLife: 40),
      toJson: (s) => s.toJson(),
      fromJson: (j) => GameState.fromJson(j),
      readCallback: (afterReadState) 
        => parent.gameHistory.listController.refresh(
          afterReadState.historyLenght
        ),
    ),
    futureActions = BlocVar<List<GameAction>>([]);



  //====================================
  // Actions
  void applyAction(GameAction action){
    if(action is GANull) return;

    this.gameState.value.applyAction(action);
    this.gameState.refresh();

    //this reversed index is due to the list UI: it goes from right to 
    //left so it needs to be reversed. also, since the last data is always a null data
    //(the current state without changes), we start at 1 instead of 0
    this.parent.gameHistory.forward(1);

    // TODO: cerca tutti i LOW PRIORITY
    // LOW PRIORITY implementa controllo del player sulla azione, così il game chiede a tutti i player
    // se l'azione avrebbe any fottuto effetto, e in caso contrario proprio non la applica a nessuno
    // ANZI, pre-check a livello di game magari
  }

  void back(){
    if(backable){
      final dataList = this.parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to 
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 2];
      this._back();
      this.parent.gameHistory.back(1, outgoingData);
    }
  }
  void _back(){
    assert(backable);
    this.futureActions.value.add(
      this.gameState.value.back()
    );
    this.gameState.refresh();
    this.futureActions.refresh();
  }
  void forward(){
    if(forwardable){
      this._forward();
    }
  }
  void _forward(){
    assert(forwardable);
    this.applyAction(this.futureActions.value.removeLast());
    this.futureActions.refresh();
  }

  void restart(){
    this.gameState.set(
      this.gameState.value.newGame(
        startingLife: this.parent.startingLife,
      )
    );
    this.parent.gameHistory.listController.refresh(1);
  }
  void startNew(Set<String> names){
    this.gameState.set(
      GameState.start(
        names, 
        startingLife: this.parent.startingLife,
      )
    );
    this.parent.gameHistory.listController.refresh(1);
  }


  void renamePlayer(String oldName, String newName){
    this.gameState.value.renamePlayer(oldName, newName);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void deletePlayer(String name){
    this.gameState.value.deletePlayer(name);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void addNewPlayer(String name){
    this.gameState.value.addNewPlayer(
      name, 
      startingLife: this.parent.startingLife,
    );
    this.parent.gameHistory.listController.rebuild();
  }


}

const _kNames = {
  "Tony",
  "Stan",
  "Peter",
  "Steve",
};