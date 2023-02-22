import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const API_KEY = "OThkYjk0ZjMtMGJiZC00NzU1LThhNzEtNWRkMDg4ZjA1Y2Ex";
const ONESIGNAL_APP_ID = "b1fe33ba-cb66-48fd-85f2-b5cb23fd37e1";
const BASE_URL = "https://onesignal.com/api/v1";

void sendNotification() async {
  try {
    final body = {
      "app_id": ONESIGNAL_APP_ID,
      "included_segments": ['Subscribed Users'],
      "contents": {
        "en": "text",
      },
      "headings": {
        "en": 'demo',
      },
      "chrome_web_image": 'https://demo-pwa-six.vercel.app/LTIMindtree192.jpg',
      "chrome_web_badge": 'https://demo-pwa-six.vercel.app/LTIMindtree192.jpg',
      "chrome_web_icon": 'https://demo-pwa-six.vercel.app/LTIMindtree192.jpg',
    };
    var url = Uri.parse('${BASE_URL}/notifications');
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Basic ${API_KEY}',
        },
        body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print(e);
  }
}
