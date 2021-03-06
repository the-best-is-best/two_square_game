import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Dio sendMessage;

  DioHelper() {
    /*
    dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.2/two_square_game/',
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
            "key=AAAAXvCCre8:APA91bHJ1FEh0_E5JE4zs-b3M4rckWz4p79JL97Q-8n24akUSuXfaDFhE4rqTAWvQLUjlpr6ImYeZ4d9fbWcC382jNQ9YW7ujSlLBVEznN_gG7vR54ofx5yQMpaGBvA_CzJUPIk26NRv"
      }, validateStatus: (_) => true),
    );
  }
}
