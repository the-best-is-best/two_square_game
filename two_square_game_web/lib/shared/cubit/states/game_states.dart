abstract class GameStates {}

class GameInitialState extends GameStates {}

class SelectedNumber extends GameStates {}

class GamePlayed extends GameStates {}

class CannotPlayHere extends GameStates {}

class DrawGame extends GameStates {}

class WinGame extends GameStates {}

class LoadingGame extends GameStates {}

class ClosedAd extends GameStates {}
