// import 'dart:convert';

// import 'package:chatgpt/models/images.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// import '../errors/exceptions.dart';
// import '../networks/network_client.dart';
// import '../utils/constants.dart';
// import 'error_message.dart';

// Future<List<Images>> submitGetImagesForm({
//   required BuildContext context,
//   required String prompt,
//   required int n,
// }) async {
//   //
//   NetworkClient networkClient = NetworkClient();
//   List<Images> imagesList = [];
//   try {
//     final res = await networkClient.post(
//       'https://api.openai.com/v1/images/generations',
//       {"prompt": prompt, "n": n, "size": "1024x1024"},
//       token: OPEN_API_KEY,
//     );
//     Map<String, dynamic> mp = jsonDecode(res.toString());
//     debugPrint(mp.toString());
//     if (mp['data'].length > 0) {
//       imagesList = List.generate(mp['data'].length, (i) {
//         return Images.fromJson(<String, dynamic>{
//           'url': mp['data'][i]['url'],
//         });
//       });
//       debugPrint(imagesList.toString());
//     }
//   } on RemoteException catch (e) {
//     Logger().e(e.dioError);
//     errorMessage(context);
//   }
//   return imagesList;
// }
