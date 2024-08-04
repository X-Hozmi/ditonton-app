import 'package:core/utils/shared.dart';
import 'package:http/http.dart' as http;

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.initClient();

  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> initialize() async {
    _clientInstance = await _instance;
  }
}
