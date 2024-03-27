class Phone {
  static String ph = '';
  Phone(e) {
    ph = e;
  }
}

class Details {
  String bio = '', name = '', phone = '';
  String uid = '';
  String photo = '';
  String email = '';
  Details(this.name, this.email, this.bio, this.photo, this.phone, this.uid);
}

class VerifiactionOtp {
  static String verify = '';
  VerifiactionOtp(v) {
    verify = v;
  }
}
