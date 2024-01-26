import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/trade_routes.dart';
import 'package:flutter/material.dart';

class JobRoutesProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<TradeRoutesSelection> _tradeRoutes = [];
  List<TradeRoutesSelection> _selectedTradeRoutes = [];

  bool _isLoading = false;
  final DateTime _date = DateTime.now();
  String _todayDate = '';

  List<TradeRoutesSelection> get tradeRoutes => _tradeRoutes;
  List<TradeRoutesSelection> get selectedTradeRoutes => _selectedTradeRoutes;

  bool get isLoading => _isLoading;
  String get todayDate => _todayDate;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  JobRoutesProvider() {
    _todayDate = '${_date.day}-${_date.month}-${_date.year}';
    _getTradeRoutesLocal();
  }

  // Metodos para manejar la lista de las rutas agregadas
  void addTradeRoute(TradeRoutesSelection tradeRoute) {
    _selectedTradeRoutes.add(tradeRoute);
    tradeRoute.selected = true;
    notifyListeners();
  }

  // Eliminar la ruta en base al id
  void removeTradeRoute(int id) {
    _selectedTradeRoutes.removeWhere((element) => element.id == id);
    _tradeRoutes.firstWhere((element) => element.id == id).selected = false;
    notifyListeners();
  }

  void accept() {
    print('Aceptado');
    for (var item in _selectedTradeRoutes) {
      print(item.id);
    }
  }

  // Obtener las rutas desde la base de datos local
  Future _getTradeRoutesLocal() async {
    isLoading = true;
    final db = await _databaseHelper.db;
    final res = await db.rawQuery("SELECT * FROM trade_routes");
    List<TradeRoutesSelection> list = res.isNotEmpty
        ? res.map((c) => TradeRoutesSelection.fromJson(c)).toList()
        : [];
    _tradeRoutes = list;
    isLoading = false;
  }
}
