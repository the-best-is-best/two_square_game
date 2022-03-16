mixin JoinRoomcubit {
  Map<String, String>? joinRoom(data) {
    if (data != null) {
      Map<String, String> returnData = {
        "id": data['id'].toString(),
        "player": data['id_user2'].toString(),
        "board": data['board'],
      };

      return returnData;
    } else {
      return null;
    }
  }
}
