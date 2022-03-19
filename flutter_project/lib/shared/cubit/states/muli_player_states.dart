abstract class MultiPlyerStates {}

class MultiPlyerInitialState extends MultiPlyerStates {}

class ServerError extends MultiPlyerStates {}

class RoomError extends MultiPlyerStates {}

class FirebaseError extends MultiPlyerStates {}

class UpdateGameAlert extends MultiPlyerStates {}

class WaitingPlayer extends MultiPlyerStates {}

class GameReady extends MultiPlyerStates {}

class LogoutGame extends MultiPlyerStates {}

class EndGame extends MultiPlyerStates {}

class SelectedNumber extends MultiPlyerStates {}

class YouCannotPlayHere extends MultiPlyerStates {}

class DrawGame extends MultiPlyerStates {}

class ClosedAd extends MultiPlyerStates {}

class StopTime extends MultiPlyerStates {}

class StartTime extends MultiPlyerStates {}
