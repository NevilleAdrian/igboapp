import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nkuzi_igbo/models/app_model.dart';
import 'package:nkuzi_igbo/models/user_model.dart';
import 'package:nkuzi_igbo/repository/hive_repository.dart';
import 'package:nkuzi_igbo/services/network_helper.dart';
import 'package:nkuzi_igbo/utils/constants.dart';
import 'package:provider/provider.dart';

class Auth extends ChangeNotifier {
  NetworkHelper _helper = NetworkHelper();
  HiveRepository _hiveRepository = HiveRepository();
  User _user;
  String _token;
  List<dynamic> _categories;

  User get user => _user;
  String get token => _token;
  dynamic get category => _categories;

  setUser(User user) => _user = user;
  setToken(String token) => _token = token;
  setCategory(List<dynamic> category) => _categories = category;

  static Auth authProvider(BuildContext context, {bool listen = false}) => Provider.of<Auth>(context, listen: listen);

  Future<void> loginUser(String email, String password) async {
    try {
      var data = await _helper.loginUser(email, password);
      var category = await _helper.getCategory();
      _setInitialData(data);
      _categories = category['data'];
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    try {
      var data = await _helper.registerUser(name, email, password);
      _setInitialData(data);
      print(_token);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  void _setInitialData(data) {
    _user = User.fromJson(data['user']);
    _token = data['token'];
    _hiveRepository.add<User>(name: kUserName, key: 'user', item: user);
    _hiveRepository.add<AppModel>(name: kAppDataName, key: 'appModel', item: AppModel(token: _token));
  }
}
