class Phone {
  static String ph = '';
  Phone(e) {
    ph = e;
  }
}

class VerifiactionOtp {
  static String verify = '';
  VerifiactionOtp(v) {
    verify = v;
  }
}

class Details {
  String? name;
  String? email;
  String? bio;
  String? photo;
  String? phone;
  String? uid;
  String? createdAt;
  String? lastOnlineStatus;
  String? status;
  String? role;
  String? pushToken;

  Details({
    this.name,
    this.email,
    this.bio,
    this.photo,
    this.phone,
    this.uid,
    this.createdAt,
    this.lastOnlineStatus,
    this.role,
    this.status,
    this.pushToken,
  });

  // Example of a factory method to create an instance from a map
  Details.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
    bio = data['bio'];
    photo = data['photo'];
    phone = data['phone'];
    uid = data['uid'];
    createdAt = data["CreatedAt"];
    lastOnlineStatus = data["LastOnlineStatus"];
    status = data["Status"];
    role = data["role"];
    pushToken = data['push_token'];
  }

  // Example of a method to convert the instance to a map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['bio'] = bio;
    _data['photo'] = photo;
    _data['phone'] = phone;
    _data['uid'] = uid;
    _data["CreatedAt"] = createdAt;
    _data["LastOnlineStatus"] = lastOnlineStatus;
    _data["Status"] = status;
    _data["role"] = role;
    _data['push_token'] = pushToken;
    return _data;
  }
}
