import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyFirebase {
  static final _db = FirebaseFirestore.instance;
  static final izin3Collection = _db.collection('izin3');
}