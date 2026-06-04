class ResponseActivity {
  String? status;
  String? message;
  List<Shift>? data;

  ResponseActivity({this.status, this.message, this.data});

  ResponseActivity.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Shift>[];
      json['data'].forEach((v) {
        data!.add(new Shift.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shift {
  int? id;
  String? userId;
  String? activity;
  String? device;
  String? timestamp;
  String? userLat;
  String? userLon;

  Shift({
    this.id,
    this.userId,
    this.activity,
    this.device,
    this.timestamp,
    this.userLat,
    this.userLon,
  });

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']?.toString();
    activity = json['activity'];
    device = json['device'];
    timestamp = json['timestamp'];
    userLat = json['user_lat']?.toString();
    userLon = json['user_lon']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
