import 'package:flutter/material.dart';
import 'package:app_noticias_daniel/ui/news_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsHome extends StatefulWidget {
  const NewsHome({Key? key}) : super(key: key);

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

String _search = "";
Map mapResponse = {};

class _NewsHomeState extends State<NewsHome> {

  Color _fundoNoticias = Colors.blue;
  Color _fundoAppBar = Colors.blue;
  Color? _fonteGeral = Colors.blue[100];

  int currentPage = 1;

  Future<Map> apicall()async{
    http.Response response;
    if(_search == ""){
      response = await http.get(Uri.parse("https://content.guardianapis.com/search?api-key=test&page=$currentPage"));
    }
    else{
      response = await http.get(Uri.parse("https://content.guardianapis.com/search?api-key=test&q=$_search&page=$currentPage"));
    }

    return jsonDecode(response.body);
  }

  int _getSize (Map data){
    if(_search == ""){
      return data.length;
    }
    else{
      return data.length + 1;
    }
  }

  Widget _createNewsColumn(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisExtent: 100.0,
      ),
      itemCount: _getSize(snapshot.data["response"]),
      itemBuilder: (context, index){
        if(index < snapshot.data["response"].length){
          return GestureDetector(
            child: Text(
              snapshot.data["response"]["results"][index]["webTitle"].toString(),
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.blue[400]
              ),
              textAlign: TextAlign.center,
            ),
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => newsPage(snapshot.data["response"]["results"][index]))
              );
            },
          );
        }
        else{
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const<Widget>[
                Icon(Icons.arrow_right, color: Colors.blue, size: 70,),
                Text("Proxima pagina", style: TextStyle(color: Colors.blue, fontSize: 22))
              ],
            ),
            onTap: (){
              setState(() {
                currentPage += 1;
              });
            },
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _fundoAppBar,
        title: Text("Info News", style: TextStyle(color: _fonteGeral)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise outros temas aqui",
                labelStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.0
                ),
                border: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: apicall(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError){
                        return Container();
                      }
                      else{
                        return _createNewsColumn(context, snapshot);
                      }
                  }
                },
              )
          ),
        ],
      ),
    );
  }
}

//child: Text(mapResponse['response']['results'][2]['webTitle'].toString(), style: TextStyle(color: _fonteGeral),),
