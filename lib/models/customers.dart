import 'dart:convert';

//Customers customersFromJson(String str) => Customers.fromJson(json.decode(str));
//String customersToJson(Customers data) => json.encode(data.toJson());

List<Customers> customersFromJson(String str) =>
    List<Customers>.from(json.decode(str).map((x) => Customers.fromJson(x)));
String customersToJson(List<Customers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customers {
  int? id;
  String? address;
  String? cod;
  String? tradename;
  String? document;
  String? email;
  String? lastname;
  String? name;
  String? phone;
  int? route;
  String? lat;
  String? lng;

  Customers({
    this.id,
    this.address,
    this.cod,
    this.tradename,
    this.document,
    this.email,
    this.lastname,
    this.name,
    this.phone,
    this.route,
    this.lat,
    this.lng,
  });

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
        address: json['address'],
        cod: json['cod'],
        tradename: json['tradename'],
        document: json['document'],
        email: json['email'],
        lastname: json['lastname'],
        name: json['name'],
        phone: json['phone'],
        route: (json['route'] is String)
            ? int.parse(json['route'])
            : json['route'],
        lat: json['lat'],
        lng: json['lng'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'cod': cod,
        'tradename': tradename,
        'document': document,
        'email': email,
        'lastname': lastname,
        'name': name,
        'phone': phone,
        'route': route,
        'lat': lat,
        'lng': lng,
      };
}
