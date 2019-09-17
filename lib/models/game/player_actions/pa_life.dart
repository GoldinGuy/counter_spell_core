import '../model.dart';

class PALife extends PlayerAction {
  final int increment;
  final int minVal;
  final int maxVal;

  const PALife(
    this.increment, 
    {
      this.minVal, 
      this.maxVal
    }
  );

  @override
  PlayerState apply(PlayerState state) 
    => state.incrementLife(increment, minVal: minVal, maxVal: maxVal);

}
