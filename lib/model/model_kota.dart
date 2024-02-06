class ModelKota {
  String? cityId;
  String? type;
  String? cityName;

  ModelKota({this.cityId, this.type, this.cityName});

  ModelKota.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city_name'];
  }

  @override
  String toString() => cityName as String;

  static List<ModelKota> fromJsonList(List list) {
    if (list.length == 0) return List<ModelKota>.empty();
    return list.map((item) => ModelKota.fromJson(item)).toList();
  }
}
