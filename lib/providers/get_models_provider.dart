// import 'dart:convert';

// import 'package:chatgpt/models/model.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// import '../errors/exceptions.dart';
// import '../networks/network_client.dart';
// import '../utils/constants.dart';
// import 'error_message.dart';

// Future<List<Model>> submitGetModelsForm({
//   required BuildContext context,
// }) async {
//   //
//   NetworkClient networkClient = NetworkClient();
//   List<Model> modelsList = [];
//   try {
//     final res = await networkClient.get(
//       "https://api.openai.com/v1/models",
//       token: OPEN_API_KEY,
//     );
//     Map<String, dynamic> mp = jsonDecode(res.toString());
//     debugPrint(mp.toString());
//     if (mp['data'].length > 0) {
//       modelsList = List.generate(mp['data'].length, (i) {
//         return Model.fromJson(<String, dynamic>{
//           'id': mp['data'][i]['id'],
//           'created': mp['data'][i]['created'],
//           'root': mp['data'][i]['root'],
//         });
//       });
//       debugPrint(modelsList.toString());
//     }
//   } on RemoteException catch (e) {
//     Logger().e(e.dioError);
//     errorMessage(context);
//   }
//   return modelsList;
// }
