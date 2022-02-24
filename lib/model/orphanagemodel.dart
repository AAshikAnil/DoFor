class OrphanageModel {
  String? uid;
  String? ownerName;
  String? type;
  String? orphangeUrl;
  String? licencePath;
  String? orphanageName;
  String? mail;
  String? location;
  String? phone;

  OrphanageModel(
      {this.uid,
      this.ownerName,
      this.type,
      this.orphangeUrl,
      this.licencePath,
      this.location,
      this.mail,
      this.orphanageName,
      this.phone});

  factory OrphanageModel.fromMap(map) {
    return OrphanageModel(
        uid: map['uid'],
        ownerName: map['ownerName'],
        type: map['type'],
        orphangeUrl: map['orpahangeUrl'],
        licencePath: map['licencePath'],
        orphanageName: map['orphangeName'],
        mail: map['mail'],
        location: map['location'],
        phone: map['phone']);
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ownerName': ownerName,
      'type': type,
      'orphangeUrl': orphangeUrl,
      "licencePath": licencePath,
      'orphanageName': orphanageName,
      'mail': mail,
      'location': location,
      'phone': phone
    };
  }
}
