// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  String? uid;
  String? name;
  String? email;
  Usermodel({
    this.uid,
    this.name,
    this.email,
  });

  Usermodel copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return Usermodel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Usermodel(uid: $uid, name: $name, email: $email)';

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ email.hashCode;
}

class Newsmodel {
  String? id;
  String? title;
  String? imageUrl;
  String? description;
  Timestamp? ntime;

  Newsmodel({this.id, this.title, this.imageUrl, this.description, this.ntime});

  Newsmodel copyWith(
      {String? id,
      String? title,
      String? imageUrl,
      String? description,
      Timestamp? ntime}) {
    return Newsmodel(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        ntime: ntime ?? this.ntime);
  }

  factory Newsmodel.fromDocument(DocumentSnapshot doc) {
    return Newsmodel(
      id: doc.id,
      title: doc['title'] != null ? doc['title'] as String : null,
      imageUrl: doc['imageUrl'] != null ? doc['imageUrl'] as String : null,
      description:
          doc['description'] != null ? doc['description'] as String : '',
      ntime: doc['ntime'] != null ? doc['ntime'] as Timestamp : null,
    );
  }
  @override
  String toString() =>
      'Newsmodel(id : $id , title : $title , description : $description , imageUrl : $imageUrl , ntime : $ntime)';
}
