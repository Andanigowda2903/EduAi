import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class AiTutorPage extends StatefulWidget {
  const AiTutorPage({Key? key}) : super(key: key);

  @override
  _AiTutorPageState createState() => _AiTutorPageState();
}

class _AiTutorPageState extends State<AiTutorPage> {
  final Gemini gemini = Gemini.instance;
  bool _isLoading = false;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "AI Tutor",
    profileImage:
    "https://cdn2.vectorstock.com/i/1000x1000/64/71/female-teacher-avatar-educacion-and-school-vector-38156471.jpg",
  );

  @override
  void initState() {
    super.initState();
    // Add welcome message
    messages.add(ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Hello! I'm your AI Tutor. I can help you with:\n• Homework questions\n• Study explanations\n• Math problems\n• Science concepts\n• Programming help\n\nWhat would you like to learn today?",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF48A9A6),
        centerTitle: true,
        title: const Text(
          "AI Tutor",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://i.pinimg.com/736x/ee/e1/d4/eee1d4114e36fa5f1dc7358c60f4b290.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: DashChat(
        inputOptions: InputOptions(
          trailing: [
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48A9A6)),
                  ),
                ),
              ),
            IconButton(
              onPressed: _isLoading ? null : _sendMediaMessage,
              icon: const Icon(Icons.image),
            )
          ],
        ),
        currentUser: currentUser,
        onSend: _isLoading ? (message) {} : _sendMessage,
        messages: messages,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    if (chatMessage.text.trim().isEmpty) return;
    
    setState(() {
      messages = [chatMessage, ...messages];
      _isLoading = true;
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      // Add a loading message
      ChatMessage loadingMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Thinking...",
      );
      setState(() {
        messages = [loadingMessage, ...messages];
      });

      gemini.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ??
              "";
          
          if (response.trim().isEmpty) {
            response = "I'm sorry, I couldn't generate a response. Please try asking your question in a different way.";
          }
          
          lastMessage.text = response;
          setState(() {
            messages = [lastMessage!, ...messages];
            _isLoading = false;
          });
        } else {
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ??
              "";
          
          if (response.trim().isEmpty) {
            response = "I'm sorry, I couldn't generate a response. Please try asking your question in a different way.";
          }
          
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
            _isLoading = false;
          });
        }
      }, onError: (error) {
        print("Gemini API Error: $error");
        // Remove loading message and add error message
        if (messages.isNotEmpty && messages.first.user == geminiUser && messages.first.text == "Thinking...") {
          messages.removeAt(0);
        }
        
        ChatMessage errorMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "I'm sorry, I'm having trouble connecting right now. Please check your internet connection and try again. If the problem persists, you can try asking a simpler question.",
        );
        setState(() {
          messages = [errorMessage, ...messages];
          _isLoading = false;
        });
      });
    } catch (e) {
      print("Error in _sendMessage: $e");
      // Remove loading message and add error message
      if (messages.isNotEmpty && messages.first.user == geminiUser && messages.first.text == "Thinking...") {
        messages.removeAt(0);
      }
      
      ChatMessage errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "I'm sorry, something went wrong. Please try again in a moment.",
      );
      setState(() {
        messages = [errorMessage, ...messages];
        _isLoading = false;
      });
    }
  }

  void _sendMediaMessage() async {
    if (_isLoading) return;
    
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Please describe this image and help me understand what I'm looking at.",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
