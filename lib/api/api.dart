import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Api {
  static var client = http.Client();

  static String url = 'https://api.carbonintensity.org.uk/intensity';

  static var baseUrl = Uri.parse(url);

  Future<Response> getCurrentCarbonIntensity() async {
    var url = Uri.parse("$baseUrl");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    return response;
  }

  Future<Response> getCurrentDayCarbonIntensity(String date) async {
    var url = Uri.parse("$baseUrl/$date/fw24h");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
