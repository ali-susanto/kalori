import 'package:dio/dio.dart';
import '../model/tips_model.dart';

class TipsApi {
  final Dio dio = Dio();
  final baseUrl = 'https://62b809d5f4cb8d63df57c091.mockapi.io/healthy';

  Future<List<TipsModel>> getTipsData() async {
    try {
      Response<List<dynamic>> response = await dio.get(baseUrl);
      if (response.statusCode == 200) {
        List<TipsModel>? tipsData =
            response.data?.map((e) => TipsModel.fromJson(e)).toList();
        return tipsData ?? [];
      }
    } on DioError catch (e) {
      e.message.toString();
    }
    return [];
  }
}
