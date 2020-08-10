import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whereto/db/model/Story.dart';

class FullScreenImage extends StatefulWidget {
  final Story story;

  FullScreenImage(this.story);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.story.city,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: new Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Container(
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.3),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.story.description,
                  style: TextStyle(fontSize: 20, color: Colors.white,),textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.story.photo),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
