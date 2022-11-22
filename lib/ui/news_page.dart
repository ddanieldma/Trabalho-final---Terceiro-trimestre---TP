import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class newsPage extends StatelessWidget {

  final Map _newsData;
  const newsPage(this ._newsData, {super.key});

  Future<void> share() async{
    await FlutterShare.share(
      title: 'Noticia', linkUrl: (_newsData["webTitle"]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _newsData["sectionName"],
          style: TextStyle(color: Colors.blue[100]),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
            child: Text(
              _newsData['webTitle'],
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 0.0),
            child: Text(
              _newsData['webUrl'],
            ),
          )
        ],
      )
      // SingleChildScrollView(
      //   padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      //   child: Text(
      //     _newsData["webUrl"]
      //   ),
      // )
    );
  }
}
