// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                    child: const Icon(Icons.arrow_back),
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
                                    const SizedBox(height: 10,),
                                Flexible(child: Text(widget.description,style: const TextStyle(fontSize: 18),)),
                               const SizedBox(height: 20,),
                                Text('Posted on ${formatdate(widget.ntime)}',style: const TextStyle(fontWeight: FontWeight.w500),)


            ],
          ),
        ),
      ),
    );
  }
}
