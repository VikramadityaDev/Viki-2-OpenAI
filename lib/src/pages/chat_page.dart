import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/models/model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat.dart';
import '../../network/api_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String messagePrompt = '';
  int tokenValue = 500;
  List<Chat> chatList = [];
  List<Model> modelsList = [];
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    getModels();
    initPrefs();
  }

  void getModels() async {
    modelsList = await submitGetModelsForm(context: context);
  }

  List<DropdownMenuItem<String>> get models {
    List<DropdownMenuItem<String>> menuItems =
        List.generate(modelsList.length, (i) {
      return DropdownMenuItem(
        value: modelsList[i].id,
        child: Text(modelsList[i].id),
      );
    });
    return menuItems;
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    tokenValue = prefs.getInt("token") ?? 500;
  }

  TextEditingController mesageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _topChat(),
                  _bodyChat(),
                  const SizedBox(
                    height: 75,
                  )
                ],
              ),
              _formChat(),
            ],
          ),
        ),
      ),
    );
  }

  void saveData(int value) {
    prefs.setInt("token", value);
  }

  int getData() {
    return prefs.getInt("token") ?? 1;
  }

  _topChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Chat GPT',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter state) {
                    return Container(
                      height: 400,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade700,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                            child: DropdownButtonFormField(
                              items: models,
                              borderRadius: const BorderRadius.only(),
                              focusColor: Colors.amber,
                              onChanged: (String? s) {},
                              decoration: const InputDecoration(
                                  hintText: "Select Model"),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Token")),
                          ),
                          Slider(
                            min: 0,
                            max: 1000,
                            activeColor: Colors.black54,
                            inactiveColor: Colors.grey.shade300,
                            value: tokenValue.toDouble(),
                            onChanged: (value) {
                              state(() {
                                tokenValue = value.round();
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: const Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    saveData(tokenValue);
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE58500),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: const Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            },
            child: const Icon(
              Icons.more_vert_rounded,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget chats() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: chatList.length,
      itemBuilder: (context, index) => _itemChat(
        chat: chatList[index].chat,
        message: chatList[index].msg,
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          children: [
            chats(),
          ],
        ),
      ),
    );
  }

  _itemChat({required int chat, required String message}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
            ),
            child: chatWidget(message),
          ),
        ),
      ],
    );
  }

  Widget chatWidget(String text) {
    return SizedBox(
      width: 250.0,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              text.replaceFirst('\n\n', ''),
            ),
          ],
          repeatForever: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Colors.white,
          child: TextField(
            controller: mesageController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: InkWell(
                onTap: (() async {
                  messagePrompt = mesageController.text.toString();
                  setState(() {
                    chatList.add(Chat(msg: messagePrompt, chat: 0));
                    mesageController.clear();
                  });
                  chatList.addAll(await submitGetChatsForm(
                    context: context,
                    prompt: messagePrompt,
                    tokenValue: tokenValue,
                  ));
                  setState(() {});
                }),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.blueGrey.shade50,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
