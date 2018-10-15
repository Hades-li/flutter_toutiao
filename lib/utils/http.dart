import 'package:dio/dio.dart';

Dio createDio() {
    Dio dio = new Dio(new Options(
        connectTimeout: 5000
    ));

    dio.interceptor.request.onSend = (Options opt) {
        // todo
        opt.headers = {
            'Content-Type': 'application/json',
            'User-Agent': 'Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1',
            'cookie': 'tt_webid=${new DateTime.now().millisecond}'
        };

        return opt;
    };
    dio.interceptor.response.onSuccess = (Response res) {
        // todo
        return res;
    };

    return dio;
}





