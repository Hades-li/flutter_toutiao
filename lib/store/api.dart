import 'package:meta/meta.dart';

class Api {
    static final host = 'http://10.0.2.2:3001';
    static final toutiaoHost = 'http://m.toutiao.com';
    static final test = 'https://httpbin.org/ip';
    static final newsList = host + '/api/news_list/';
    static final detailData = host + '/api/news_detail/';

    static String getUrl({@required int type, int ms = 0}) {
        String path;
        switch (type) {
            case 0:
                path =
                '/list/?tag=news_hot&ac=wap&count=20&format=json_raw&as=A115DBEB9598067&cp=5BB578A0B6477E1&min_behot_time=$ms';
                break;
            case 1:
                path =
                '/list/?tag=news_society&ac=wap&count=20&format=json_raw&as=A195B9F229018CD&cp=592991783C9D8E1&min_behot_time=$ms';
                break;
            case 2:
                path =
                '/list/?tag=news_entertainment&ac=wap&count=20&format=json_raw&as=A1C51992996195E&cp=5929D119B58EFE1&min_behot_time=$ms';
                break;
            case 3:
                path =
                '/list/?tag=news_sports&ac=wap&count=20&format=json_raw&as=A1054902B911A1E&cp=592991AA81AEAE1&min_behot_time=$ms';
                break;
            case 4:
                path =
                '/list/?tag=news_essay&ac=wap&count=20&format=json_raw&as=A195495279C19DE&cp=5929C1F91DFEEE1&min_behot_time=$ms';
                break;
            case 5:
                path =
                '/list/?tag=news_tech&ac=wap&count=20&format=json_raw&as=A1854972BABC6FF&cp=592A9CC64FCFAE1&max_behot_time=$ms';
                break;
            case 6:
                path =
                '/list/?tag=news_finance&ac=wap&count=20&format=json_raw&as=A145E9025A6C78B&cp=592ACC87687B1E1&max_behot_time=$ms';
                break;
            case 7:
                path =
                '/list/?tag=news_fashion&ac=wap&count=20&format=json_raw&as=A1353902AA9C7F9&cp=592ADCD7CF89AE1&max_behot_time=$ms';
                break;
            default: // 推荐
                path =
                '/list/?tag=news_hot&ac=wap&count=20&format=json_raw&as=A1A59982B911729&cp=5929E12752796E1&min_behot_time=$ms';
        }
        return '$toutiaoHost$path';
    }
    static String getDetailUrl({@required String id}) {
        final itemId = id;
        return '$toutiaoHost/i$itemId/info/';

    }
}