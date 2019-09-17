import '../model.dart';

class PANull extends PlayerAction {
  const PANull();

  @override
  PlayerState apply(PlayerState state) {
    return state;
  }

  static const PANull instance = const PANull();
}

