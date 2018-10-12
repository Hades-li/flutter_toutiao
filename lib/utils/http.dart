import 'package:dio/dio.dart';


Dio createDio() {
    Dio dio = new Dio(new Options(
        connectTimeout: 5000
    ));

    dio.interceptor.request.onSend = (Options opt) {
        // todo

        return opt;
    };
    dio.interceptor.response.onSuccess = (Response res) {
        // todo

        return res;

    };

    return dio;
}





