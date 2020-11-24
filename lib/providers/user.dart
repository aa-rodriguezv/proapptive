import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  String id;
  String email;
  String directBossEmail;
  List<String> subrogatesEmail;
}
