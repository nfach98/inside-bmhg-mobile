class ResponseActivity {
  String? status;
  String? message;
  List<Data>? data;

  ResponseActivity({this.status, this.message, this.data});

  ResponseActivity.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? userId;
  String? activity;
  String? device;
  String? timestamp;
  String? userLat;
  String? userLon;

  Data({
    this.id,
    this.userId,
    this.activity,
    this.device,
    this.timestamp,
    this.userLat,
    this.userLon,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    activity = json['activity'];
    device = json['device'];
    timestamp = json['timestamp'];
    userLat = json['user_lat'];
    userLon = json['user_lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['activity'] = activity;
    data['device'] = device;
    data['timestamp'] = timestamp;
    data['user_lat'] = userLat;
    data['user_lon'] = userLon;
    return data;
  }
}
