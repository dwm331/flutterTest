class Spot {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String opentime;
  final String picture1;

  const Spot({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.opentime,
    required this.picture1,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      placeId: json["Id"] as String,
      name: json["Name"] as String,
      address: json["Add"] as String,
      latitude: double.parse(json["Py"] as String),
      longitude: double.parse(json["Px"] as String),
      description: json["Description"] as String,
      opentime: json["Opentime"] as String,
      picture1: json["Picture1"] as String,
    );
  }
}
