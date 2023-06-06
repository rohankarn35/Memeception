import 'dart:convert';

import 'package:http/http.dart';
class APIModel{
  static MemeModel() async{

    Response response = await get(Uri.parse("https://meme-api.com/gimme"));
    // print(response.body);
    Map data = jsonDecode(response.body);
    print(data["url"]);
    String imgdat = data["url"];
    return imgdat;

  }
}