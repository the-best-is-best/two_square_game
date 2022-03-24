mixin JoinRoomcubit {
  Map<String, String>? joinRoom(data) {
    if (data != null) {
      Map<String, String> returnData = {
        "id": data['id'].toString(),
        "player": data['yourId'].toString(),
        "board": data['board'],
      };

      return returnData;
    } else {
      return null;
    }
  }
}
