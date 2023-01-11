import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:kalori/enums.dart';
import 'package:kalori/model/data_object_model.dart';
import 'package:kalori/model/users_model.dart';

class AuthService with ChangeNotifier {
  List<DataObjectModel> makanan = [];
  var dataHariIni =
      Kandungan(karbohidrat: '', protein: '', lemak: '', kalori: '');
  bool isAuth = false;
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var user = UsersModel();

  DataState _stateType = DataState.loading;
  DataState get stateType => _stateType;

  String errorMessage = '';

  void changeState(DataState s) {
    _stateType = s;
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    changeState(DataState.loading);
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;
        user = UsersModel.fromJson(currUserData);
        await getDataMakanan();
        makanan.clear();

        isAuth = isSignIn;

        notifyListeners();
        changeState(DataState.succes);
        return true;
      }
      notifyListeners();
      return false;
    } catch (err) {
      changeState(DataState.error);
      notifyListeners();
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isLogin = await _googleSignIn.isSignedIn();

      if (isLogin) {
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        CollectionReference users = firestore.collection('users');

        final checkuser = await users.doc(_currentUser!.email).get();

        if (checkuser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "userName":userCredential!.additionalUserInfo!.username,
            "fullName": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });

           users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user = (UsersModel.fromJson(currUserData));
        isAuth = isLogin;

        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      isAuth = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getDataMakanan() async {
    makanan.clear();
    var tanggal = DateFormat('dd MM yyyy').format(DateTime.now());
    double totalKalori = 0;
    double totalKarbohidrat = 0;
    double totalProtein = 0;
    double totallemak = 0;

    try {

      CollectionReference users = firestore.collection("users");
      final listMakanan =
          await users.doc(_currentUser!.email).collection("makanan").get();
      if (listMakanan.docs.isNotEmpty) {
        for (var element in listMakanan.docs) {
          var data = element.data();
          debugPrint('data length: ' + DataObjectModel.fromJson(data).nama);
          debugPrint('data length: ' + data.toString());

          makanan.add(DataObjectModel.fromJson(data));
        }
        

        for (var item in makanan) {
          if (DateFormat('dd MM yyyy').format(DateTime.parse(item.tanggal)) ==
              tanggal) {
            totalKalori += double.parse(item.kandungan.kalori);
            totalKarbohidrat += double.parse(item.kandungan.karbohidrat);
            totalProtein += double.parse(item.kandungan.protein);
            totallemak += double.parse(item.kandungan.lemak);
          } else {
            debugPrint('object');
          }
        }
        dataHariIni = Kandungan(
            karbohidrat: totalKarbohidrat.toStringAsFixed(1),
            protein: totalProtein.toStringAsFixed(1),
            lemak: totallemak.toStringAsFixed(1),
            kalori: totalKalori.toStringAsFixed(1));

        changeState(DataState.succes);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
      changeState(DataState.error);
    }
  }

  Future addDataMakanan(
      {required String nama,
      required String tanggal,
      required String karbohidrat,
      required String protein,
      required String lemak,
      required String kalori}) async {
    CollectionReference users = firestore.collection("users");

    try {
      await users.doc(_currentUser!.email).collection("makanan").add({
        "nama": nama,
        "tanggal": tanggal,
        "kandungan": {
          "karbohidrat": karbohidrat,
          "protein": protein,
          "lemak": lemak,
          "kalori": kalori
        },
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
