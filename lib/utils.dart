import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

Future<String> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('user_id');
  if (id == null) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    id = List.generate(12, (i) => chars[Random().nextInt(chars.length)]).join();
    await prefs.setString('user_id', id);
  }
  return id;
}
