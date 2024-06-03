import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
class News extends StatefulWidget {
  const News(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.ntime});
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp? ntime;
  @override
  State<News> createState() => _NewsBodyState();
}

class _NewsBodyState extends State<News> {
  String formatdate(Timestamp ?ntime){
      DateTime dateTime = ntime!.toDate();
    String time =DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
    
    return time;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                const  SizedBox(width: 10,),
                     Flexible(
                      child: Text(
                        widget.title,
                        style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500),
                      // overflow: TextOverflow.visible,
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Image(
                                    image: NetworkImage(
                                       widget.imageUrl),
                                    height: 270,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    fit: BoxFit.cover),
                                    SizedBox(height: 10,),
                                Flexible(child: Text(widget.description,style: TextStyle(fontSize: 18),)),
                                SizedBox(height: 20,),
                                Text('Posted on ${formatdate(widget.ntime)}',style: TextStyle(fontWeight: FontWeight.w500),)


            ],
          ),
        ),
      ),
    );
  }
}
