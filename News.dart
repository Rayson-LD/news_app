
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  var name,image,title,desc;
  String errorMessage='';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }
  Future searchNews(String input) async{
    try{
      var result = await http.get("https://newsapi.org/v2/everything?q=$input&from=2021-04-18&sortBy=publishedAt&apiKey=");
      var get = json.decode(result.body);
      setState(() {
        this.name = get["name"];
        errorMessage = '';
      });
    }
    catch(error)
    {
      errorMessage='Sorry!We are not able to receive any information right now. Please check your internet connection';
    }

  }
  Future fetchNews() async
  {
      var result = await http.get(
          "https://newsapi.org/v2/everything?sources=tesla&from=2021-05-17&to=2021-05-17&sortBy=popularity&apiKey=");
      var get = json.decode(result.body);
      setState(() {
          this.image = get["urlToImage"];
          this.title = get["title"];
          this.desc = get["description"];
      });

  }
  void onSubmit(String input) async{
    await searchNews(input);
    await fetchNews();
}
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body :Container(
          width:100,
          child : FutureBuilder(
              future: fetchNews(),
              builder: (context,snapshot){
                if(snapshot.hasData)
                  {
                    return ListView.builder(itemBuilder: (context,index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.network(image),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children:[
                               Text(title),
                               Text(desc),
                               ],
                               ),
                            ],
                          ),
                        ],
                      );
                    }
                      );
                    }
                else if(snapshot.hasError)
                  {
                    return Text('${snapshot.error}');
                  }
                else
                  return CircularProgressIndicator();
                  }
          )
        )
      ),
    );
  }
}
