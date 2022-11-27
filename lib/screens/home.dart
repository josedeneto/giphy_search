import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'giphy_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int offset = 0;
  String? _search;
  var url = Uri.parse(
      "https://api.giphy.com/v1/gifs/trending?api_key=ZwW0ENuNwS6bkmiBoHr0CI1lMqEKFKio&limit=8&rating=g");
  Future<Map?> getGiphys() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(url);
    } else {
      var urlDogs = Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=ZwW0ENuNwS6bkmiBoHr0CI1lMqEKFKio&q=$_search&limit=5&offset=$offset&rating=g&lang=en");
      response = await http.get(urlDogs);
    }
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Procurar',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getGiphys(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGiphyTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  _createGiphyTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      itemCount: _getCount(snapshot.data['data']),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      GiphyPage(giphydatas: snapshot.data['data'][index]),
                ),
              );
            },
            child: Image.network(
              snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              setState(
                () {
                  offset += 5;
                  offset = 0;
                },
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                Text('Carregar mais...'),
              ],
            ),
          );
        }
      },
    );
  }
}
