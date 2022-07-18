import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gif_search_engine/user_interface/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_share/flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';


class HomePage extends StatefulWidget{
  @override
 _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  String _search = '';
  int _offset = 0;

  _getGifs() async {

    final Uri _urlTrends = Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=kctm8LChCETpVvLXWFPNTxrVAKYTqreG&limit=25&rating=g");
    final Uri _urlSearch = Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=kctm8LChCETpVvLXWFPNTxrVAKYTqreG&q=$_search&limit=25&offset=$_offset&rating=g&lang=en');

    http.Response response;
    if(_search == null || _search == ''){
      response = await http.get(_urlTrends);
    }else{
      response = await http.get(_urlSearch);
    }
    return json.decode(response.body);
  }

  @override
  void initState(){
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar",
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: Colors.white ),
                    gapPadding: 5.0,

                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: Colors.white ),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState((){
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 400.0,
                      height: 400.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 4.0,
                      ),
                    );
                  default :
                    if(snapshot.hasError) return Container();
                    else return _createGifGrid(context, snapshot);
                }
              },
            ),
          )
        ]
      ),
    );
  }

  int _getCount(List data){
    if(_search == null || _search == ''){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createGifGrid(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if(_search == null || index < snapshot.data["data"].length){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]['fixed_height']["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  GifPage(snapshot.data["data"][index])),
              );
            },
            onLongPress: (){
              FlutterShare.share(linkUrl : snapshot.data["data"][index]["images"]['fixed_height']["url"],title: snapshot.data["data"][index]["title"]);
            },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar  mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0
                    ),
                  )
                ],
              ),
              onTap: (){
                setState((){
                  _offset += 25;
                });
              },
            ),
          );
        }
      },
    );
  }
}