import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();
final fireStore = FirebaseFirestore.instance;
final userRf = fireStore.collection('users');
final questionPaperRF = fireStore.collection('questionPapers');
DocumentReference questionRF({
  required String paperId,
  required String questionId,
}) =>
    questionPaperRF.doc(paperId).collection("questions").doc(questionId);
