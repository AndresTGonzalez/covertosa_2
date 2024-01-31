import 'dart:convert';

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));
String productsToJson(List<Products> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  int? id;
  String? code;
  String? shortname;
  num? price;
  String? category;
  int? taxable;
  int? stock;
  int? present;
  int? amount = 0;

  Products({
    this.id,
    this.code,
    this.shortname,
    this.price,
    this.category,
    this.taxable,
    this.stock,
    this.present,
    this.amount,
  });

  int? totalPages;
  late List<Products> data;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
        code: json['code'],
        shortname: json['shortname'],
        price: num.parse(json['price'].toString()),
        category: json['category'],
        taxable: (json['taxable'] is String)
            ? int.parse(json['taxable'])
            : json['taxable'],
        stock: (json['stock'] is String)
            ? int.parse(json['stock'])
            : json['stock'],
        present: (json['present'] is String)
            ? int.parse(json['present'])
            : json['present'],
      );

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'code': this.code,
        'shortname': this.shortname,
        'price': this.price,
        'category': this.category,
        'taxable': this.taxable,
        'stock': this.stock,
        'present': this.present,
      };
}
