import 'dart:convert';

import 'package:crypto/crypto.dart';

String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
// CompareHashAndPassword
String comparePassword(String hashedPassword,String password ){
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  if(hashedPassword == hash.toString()){
    return "true";
  }else{
    return "false";
  }
}