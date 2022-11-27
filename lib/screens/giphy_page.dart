import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class GiphyPage extends StatelessWidget {
  const GiphyPage({
    Key? key,
    required this.giphydatas,
  }) : super(key: key);
  final Map giphydatas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(giphydatas['title']),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
             await Share.share('check out my website https://example.com');
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(giphydatas['images']['fixed_height']['url']),
      ),
    );
  }
}
