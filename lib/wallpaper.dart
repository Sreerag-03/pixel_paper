import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixel_paper/fullscreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;

  @override 
  void initState(){
    super.initState();
    fetchapi();
  }


  fetchapi()async{
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),headers: {'Authorization':'Scs9G3pB7tuf9fI9dyp6ZuHcRk7RXH19i4X3JmWLiqCHibfgurOYjrc0'}).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadmore()async{
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page'+page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':'Scs9G3pB7tuf9fI9dyp6ZuHcRk7RXH19i4X3JmWLiqCHibfgurOYjrc0'
    }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 2/3,
                    mainAxisSpacing: 2,
                    ),
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Fullscreen(imageurl: images[index]['src']['large2x'])));
                    },
                    child: Container(color: Colors.white,
                    child: Image.network(images[index]['src']['tiny'],fit: BoxFit.cover,),
                    ),
                  ); 
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: Container(
                child: Center(
                  child: const Text(
                    "Load more",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
