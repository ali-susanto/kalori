import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../enums.dart';
import '../../model/tips_model.dart';
import '../../service/tips_api.dart';


class TipsViewModel with ChangeNotifier {
  List<TipsModel> _tipsData = [];
  List<TipsModel> get tipsData => _tipsData;

  DataState _stateType = DataState.loading;
  DataState get stateType => _stateType;

  String errorMessage = '';

  void changeState(DataState s) {
    _stateType = s;
    notifyListeners();
  }

  void getData() async {
    try {
      changeState(DataState.loading);
      List<TipsModel>? listData = await TipsApi().getTipsData();

      if (listData.isNotEmpty) {
        _tipsData = listData;
        notifyListeners();
        changeState(DataState.succes);
      } else {
        notifyListeners();
        changeState(DataState.error);
        errorMessage = 'Gagal mendapatkan data';
      }
    } catch (e) {
      changeState(DataState.error);
      debugPrint(e.toString());
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
