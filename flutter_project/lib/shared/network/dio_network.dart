import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Dio sendMessage;

  DioHelper() {
    /* dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.7/two_square_game/',
      receiveDataWhenStatusError: false,
    ));
*/
// http://michelleaccademy.epizy.com/two_square_game/

    dio = Dio(BaseOptions(
      baseUrl: 'http://michelleacademy.getenjoyment.net/two_square_game/',
      receiveDataWhenStatusError: true,
    ));

    sendMessage = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/send',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> postData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio.post(
      url,
      data: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> putData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio.put(
      url,
      data: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> postNotification(
      {required String to, required Map data}) async {
    Map<String, dynamic> query = {
      "to": "/topics/$to",
      "data": {"listen": data}
    };
    return await sendMessage.post(
      "",
      data: query,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAReLpKTc:APA91bGR2YXjI0zEIMtwNf5zYDZhdEoPnVVsFLcyu7-od8n3SaDR7JMH_xr6xvPRNjBAj3m1tFgqrv8eo6ZLfHIQv8C39x-6zCpAaV3d0-m1nDWs4Lv4UmRWKZPxwTGP8nTp2vZUMpc9"
      }, validateStatus: (_) => true),
    );
  }
}
