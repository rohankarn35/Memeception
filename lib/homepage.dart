import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_meme_generator/APIFETCH/APIMODEL.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class home extends StatefulWidget {
  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isloading = true;
  String imgurl = "";
  String bttntxt = "Start";

  void ImageMeme() async {
    try {
      String geturl = await APIModel.MemeModel();
      bttntxt = "Generate More";
      setState(() {
        imgurl = geturl;
        isloading = false;
      });
    } catch (e) {
      Container(
        child: Text("Error may be caued due to internet connection"),
      );
    }
  }

  shareImage() async {
    final uri = Uri.parse(imgurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: 'Meme Shared via Memeception App');
  }
   late StreamSubscription subscription;
  bool isconnected = false;
  bool isalert = false;

  @override
  void initState() {
    // TODO: implement initState
    getconnectivity();
    super.initState();
  }

  getconnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isconnected = await InternetConnectionChecker().hasConnection;
          if (!isconnected && isalert == false){
            showDialogBox();
            setState(() {
              isalert = true;
            });
          }
        },
      );

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memeception"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
         
            
            
           itemBuilder: (BuildContext context) {
    return  [
      PopupMenuItem(
        child: Text("Developed By Rohan Karn"),
        // onTap: (){
        //   _launchURL("https://www.rohankarn.com.np/");
        // },
      ),
      // PopupMenuItem(
      //   child: Text("GitHub"),
      //   onTap: (){
      //     _launchURL('https://github.com/rohankarn35');
      //   },
      // ),
     
    ];
  },
          
          
          
          )
          
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 40,),
          SizedBox(
            height: 100,
          ),

          InkWell(
            onDoubleTap: () async {
              //print("share cllicked");
              await shareImage();
            },
            child: 
            Container(
                margin: EdgeInsets.all(20),
                height: 400,
                width: 500,
                child: isloading
                    ? const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Double-tap the image to share")
                        ],
                      ))
                    : Image.network(
                        imgurl,
                        height: 1080,
                        width: 740,
                                  )),
          ),
         const  SizedBox(
            height: 90,
          ),
          ElevatedButton(
              onPressed: () {
                print("Clicked()");
                ImageMeme();
              },
              style: const ButtonStyle(
                  shadowColor: MaterialStatePropertyAll(Colors.black),
                  elevation: MaterialStatePropertyAll(10)),
              child: Text(
                bttntxt,
                style: TextStyle(fontSize: 15),
              )),
         const SizedBox(
            height: 105,
          ),
         const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Meme may contain adult content !!",
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ],
          ),

          // Spacer(),
          // //   SizedBox(height: 100,),

          // Text("Developed By Rohan Karn")
        ]),
      ),
    );
    
  }
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isalert = false);
                isconnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isconnected && isalert == false) {
                  showDialogBox();
                  setState(() => isalert = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  // Future<void> _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  
}
