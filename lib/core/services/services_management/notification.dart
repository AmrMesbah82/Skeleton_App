import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;


class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "services-v2-scheme",
      "private_key_id": "4c998660e752b50f188eebd698f3cf720d745ecc",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCwq8BY2W+xjWpl\nRe8LnJilSuS8mHU6feV6jicQ5cbVq8PpKWIrbpzwq1vFfyYXpR/+65rYF2bjfrL0\nMVpeOZKXR1e6FLJ1rnKRSyO/vJfh4xmwQ5tli/qqulXEcUCZzBZP1AVbEFpdTq2L\nf+g2Os4nBR20CGhID56a7gQWtO3cfePgRjLhaUBYYhd6dR4FiPWshyUQZHFuT6wk\nBaSwsNInxEuMwBv+f7injwGeNAmbusmBDQgxVdItTSJLhKtEZWwott8xLMuVUyOL\nNUUbHMM049kV7Q5pYD0+c2dIrX6oAAQDdJEsldo4JJbjumpGdfVGLjA2Myx8XsaO\n+AW1m5tFAgMBAAECggEAO+sUQk4EbrBqnExapZKHxs+ewkPmxl66fJVHtJhplkA6\nIpLxg49xVMKZTmMwNSbAskGP86gEMjXfVaiDYJ+gEwSUQT0RxY3Tt2lHh5jb3jWa\nmchkJM2Tx2GJAyXx5fdsvchHxLnIHAs6GqzXwcSx9FPs3glX7NC3Vw5Qfq8AWR4b\nhHWnl5v9qmqlA7tOH8tYb3pqiWsoliyHwsgA+BtbLctvOfvXQe56Qdy9Xv94d7cs\nVjJ7zJVZaaCqmogsCIVc4RCX+Ax7z3PoPZ6HddM941S3sBHY1FkANokrBrNzLgdA\neSfOgw281CrHFKqA5PRU/goYPOU/OqRM5Sjxq6YlBQKBgQC40/LUJMuf0cdMalMa\nd+neiaDvwwt1bRVmhmaS6Z+osF+V7kWJJ46oVwmImCVVZbXlfbP0q99dLUDusFe2\n44Wh+L0JEb0Ivo4vUiGId+uyz3eusWqLKUIUZCg42lmA68MMs8BcL8U6TQto1ALK\nkWaIscCgSaXStSO6Izt28CZqpwKBgQD0s7JDKSljl+lz85+RbMeSYysysIdL2hnr\ngrIz8uYkB0NjliC4/P+kiokBhVbj8vH3fxgj97QNg/ftlr5y776XeIfnmVgm25wm\no/82M2ripFjoeAC5Dt7u9Z7Qrgmcw4YVxT+hZGCs+vZn2emF2Fvd1r6wPgh1x1QG\nGpvlXWBEMwKBgH/jT/uQdkDgo5lxXI1M+crcyjn8aJpY31zwlFsFQk8zswAIPZ8Y\nevJqPxN/yx1a4lCn+PPMVSKg5HQEGr1Wkymu9gYnevho+fMuTjuiVrmEKpj68/DU\nnH+FiftEwnedKnpIikp/V2Xu130ybbgCgcMF03ZVX2L7qXvrUwMKSlqzAoGAUBrb\nSl0ZLX83bzvbirG/i05nf8qGH/Cf95brW1IywKyYBOvKfoRj86teOl86GJkZWNoE\nPxIBoUMIUIC+i8Wr8M4GP2zVjLLrpUKec1HVtafzavaN1gbmN/e0K8AtaWIgbNQL\nhnvjofzt2QVfCu/O8wovlmZYQqYj/XOMgUNWFj0CgYBCJJzRD54N0LBGrzo3N7Nx\npEva7SOUymwYVI8r1p6a3mDg8DVFF//O5LgWrEpYQZXvqOGBOHThNabH/wjjDhO2\nklfU+qGplqKY6iT52LQZY8INvsVTkJvOr1/BD3AqisUtjAvB6XzcoG3O69X9Xrk5\nAiZBtHg3jKqi/gNhWxwx1w==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-2szdm@services-v2-scheme.iam.gserviceaccount.com",
      "client_id": "108712132861240366762",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-2szdm%40services-v2-scheme.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(String title, String body) async {
    final String accessToken = await getAccessToken();

    if (accessToken.isEmpty) {
      print('❌ Access token retrieval failed.');
      return;
    }

    print('✅ Access Token: $accessToken');

    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/services-v2-scheme/messages:send';

    final Map<String, dynamic> message = {
      "message": {
        "topic": "all",
        "notification": {
          "title": "amr",
          "body": "mesbah"
        },
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(endpointFCM),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(message),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully.');
      } else {
        print('❌ Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }
}
