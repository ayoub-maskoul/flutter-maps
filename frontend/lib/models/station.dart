
class Station {

  final String id;
  final String city;
  final String service;
  final double price;
  final double lat;
  final double lng;
  Station({
    required this.id,
    required this.city,
    required this.service,
    required this.price,
    required this.lat,
    required this.lng,
  });
  factory Station.fromJson(Map<String, dynamic> json){
      return Station(
      id: json['id'].toString(),
      city: json['city'],
      service: json['service'],
      price: json['price'].toDouble(),
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
    }

    static List<Station> fromList(List<dynamic> list) {
    return list.map((item) => Station.fromJson(item)).toList();
  }

    @override
  String toString() {
    return 'Station{id: $id, city: $city, service: $service, price: $price, lat: $lat, lng: $lng}';
  }

}