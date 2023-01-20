// import 'dart:convert';

// import 'package:chatgpt/models/chat.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// import '../errors/exceptions.dart';
// import '../networks/network_client.dart';
// import '../utils/constants.dart';
// import 'error_message.dart';

// Future<List<Chat>> submitGetChatsForm({
//   required BuildContext context,
//   required String prompt,
//   required int tokenValue,
//   String? model,
// }) async {
//   //
//   NetworkClient networkClient = NetworkClient();
//   List<Chat> chatList = [];
//   try {
//     final res = await networkClient.post(
//       "https://api.openai.com/v1/completions",
//       {
//         "model": model ?? "text-davinci-003",
//         "prompt": prompt,
//         "temperature": 0,
//         "max_tokens": tokenValue
//       },
//       token: OPEN_API_KEY,
//     );
//     Map<String, dynamic> mp = jsonDecode(res.toString());
//     debugPrint(mp.toString());
//     if (mp['choices'].length > 0) {
//       chatList = List.generate(mp['choices'].length, (i) {
//         return Chat.fromJson(<String, dynamic>{
//           'msg': mp['choices'][i]['text'],
//           'chat': 1,
//         });
//       });
//       debugPrint(chatList.toString());
//     }
//   } on RemoteException catch (e) {
//     Logger().e(e.dioError);
//     errorMessage(context);
//   }
//   return chatList;
// }
