// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<TradeRoutes> tradeFromJson(String str) => List<TradeRoutes>.from(
    json.decode(str).map((x) => TradeRoutes.fromJson(x)));
String tradeToJson(List<TradeRoutes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TradeRoutes {
  int? id;
  int? route_id;
  int? user_id;
  String? seller;
  String? code;

  TradeRoutes({this.id, this.route_id, this.user_id, this.seller, this.code});

  factory TradeRoutes.fromJson(Map<String, dynamic> json) => TradeRoutes(
      id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
      route_id: (json['route_id'] is String)
          ? int.parse(json['route_id'])
          : json['route_id'],
      user_id: (json['user_id'] is String)
          ? int.parse(json['user_id'])
          : json['user_id'],
      seller: json['seller'],
      code: json['code']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'route_id': route_id,
        'user_id': user_id,
        'seller': seller,
        'code': code
      };
}

class TradeRoutesSelection extends TradeRoutes {
  bool selected = false;

  TradeRoutesSelection(
      {int? id,
      int? route_id,
      int? user_id,
      String? seller,
      String? code,
      this.selected = false})
      : super(
            id: id,
            route_id: route_id,
            user_id: user_id,
            seller: seller,
            code: code);

  factory TradeRoutesSelection.fromJson(Map<String, dynamic> json) =>
      TradeRoutesSelection(
          id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
          route_id: (json['route_id'] is String)
              ? int.parse(json['route_id'])
              : json['route_id'],
          user_id: (json['user_id'] is String)
              ? int.parse(json['user_id'])
              : json['user_id'],
          seller: json['seller'],
          code: json['code'],
          selected: false);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'route_id': route_id,
        'user_id': user_id,
        'seller': seller,
        'code': code,
        'selected': selected
      };
}
