abstract class MultiPlyerStates {}

class MultiPlyerInitialState extends MultiPlyerStates {}

class ServerError extends MultiPlyerStates {}

class UpdateGameAlert extends MultiPlyerStates {}

class WaitingPlayer extends MultiPlyerStates {}

class GameReady extends MultiPlyerStates {}

// class WinGame extends MultiPlyerStates {}

// class LostGame extends MultiPlyerStates {}

class EndGame extends MultiPlyerStates {}

class SelectedNumber extends MultiPlyerStates {}

class YouCannotPlayHere extends MultiPlyerStates {}

class DrawGame extends MultiPlyerStates {}
