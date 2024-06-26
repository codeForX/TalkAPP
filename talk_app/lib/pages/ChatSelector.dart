import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Chat.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';

class ChatSelector extends StatefulWidget {
  final User user;

  const ChatSelector({super.key, required this.user});

  @override
  ChatSelectorState createState() => ChatSelectorState();
}

class ChatSelectorState extends State<ChatSelector> {
  late Stream<Map<String, dynamic>> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = chatListStream(widget.user.uid);
  }

  void _createChat(BuildContext context) {
    String userID = widget.user.uid;
    String title = "";
    String language = "English";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Create New Chat')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(hintText: "Chat Title"),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Color(0xFF7AA7FF),
                ),
                value: language,
                onChanged: (String? newValue) {
                  language = newValue!;
                },
                items: <String>[
                  'English',
                  'Spanish',
                  'French',
                  'German',
                  'Hebrew',
                  'Ukrainian'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                createChat(userID, language, title);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildChat(int chatId, String title, String subtitle) {

    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8), // Rounded rectangle corners
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: ListTile(
          title: Text(title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 24)), // Providing a fallback value for null
          subtitle: Text(subtitle,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface)), // Providing a fallback value for null
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Chat(chatId: chatId),
              ),
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Chat', style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching favorites: ${snapshot.error}'),
            );
          } else {
            List<dynamic> chatIDs = snapshot.data?['chatIDs'] ?? [];
            List<dynamic> chatNames = snapshot.data?['chatNames'] ?? [];
            List<dynamic> nativeLanguages =
                snapshot.data?['nativeLanguages'] ?? [];
            List<dynamic> foreignLanguages =
                snapshot.data?['forignLanguages'] ?? [];
            return ListView.builder(
              itemCount: chatIDs.length,
              itemBuilder: (context, index) {
                return buildChat(
                    chatIDs[index], chatNames[index], foreignLanguages[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createChat(context),
        tooltip: 'New Chat',
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
