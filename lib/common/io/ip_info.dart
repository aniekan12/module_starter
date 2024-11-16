import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class IpInfo {
  IpInfo._();

  static final IpInfo _instance = IpInfo._();

  factory IpInfo() {
    return _instance;
  }

  Future<String?> getPublicIP() async {
    try {
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      log(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'];
      }
    } catch (e) {
      log('Failed to fetch IP: $e');
    }
    return null;
  }
}
