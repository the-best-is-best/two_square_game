mixin CreateRoomController {
  Map<String, String>? createRoom(data) {
    if (data != null) {
      Map<String, String> returnData = {
        "id": data['id'].toString(),
        "player": data['id_user1'].toString(),
        "board": data['board'],
      };

      return returnData;
    } else {
      return null;
    }
  }
}
