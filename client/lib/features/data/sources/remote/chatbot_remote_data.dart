import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../lib/core/common/constants/server_constant.dart';
import '../../../../core/common/utils/firebase_util.dart';
import '../../../../core/errors/exception.dart';

abstract class ChatBotRemoteData {
  Future<Map<String, dynamic>> send(String message);
}

class ChatBotRemoteDataImpl implements ChatBotRemoteData {
  final http.Client client;

  ChatBotRemoteDataImpl(this.client);

  @override
  Future<Map<String, dynamic>> send(String message) async {
    try {
      final res = await client.post(
        Uri.parse('${ServerConstant.serverURL}/chatbot/navigate'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "conversation_id": currentUser!.uid,
          "text": message,
        }),
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        throw ServerException(resBodyMap['detail']);
      }
      return resBodyMap;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
