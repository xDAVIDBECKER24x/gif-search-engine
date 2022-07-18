import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: (){
              FlutterShare.share(
                  title: _gifData["title"],
                  linkUrl: _gifData["images"]['fixed_height']["url"],
              );
            },
            icon: Icon(Icons.share))
        ],
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child:Image.network(
          _gifData["images"]['fixed_height']['url'],
          height: 300.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
