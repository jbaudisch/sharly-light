import 'package:sharly_app_light/models/activity_index.dart';
import 'package:http/http.dart' as http;

final _activity_index_uri = Uri.parse("uri");

class APIHelper {

  final _client = http.Client();

  Future<ActivityIndex> getLatestActivityIndex() async {
    final response = await _client.get(_activity_index_uri);
    if (response.statusCode == 200) {
      return ActivityIndex.fromValue(response.body);
    } else {
      throw Exception("Failed to load activity index");
    }
  }
}