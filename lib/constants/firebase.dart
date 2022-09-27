import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

final Future<FirebaseApp> firebaseInitialization = kIsWeb
    ? Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA8lEO0ryGt4eAev0dvpmVNk2oRk8QPQN8",
            appId: "1:118740464315:web:f39b062b03d2a1777b2f9e",
            messagingSenderId: "118740464315",
            projectId: "ikramenterprise-c849d"))
    : Firebase.initializeApp();


FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

FirebaseStorage firebaseStorage = FirebaseStorage.instance;