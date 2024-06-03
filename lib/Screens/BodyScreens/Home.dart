import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Models/Model.dart';
import 'package:newsapp/Providers/GreetProv.dart';
import 'package:newsapp/Providers/NewsProv.dart';
import 'package:newsapp/Screens/LoginScreens/Login.dart';
import 'package:newsapp/Utilities/FirebaseDatabase.dart';
import 'package:provider/provider.dart';
import 'package:newsapp/Screens/BodyScreens/News.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> types = ['Topstories', 'Technology', 'Sports'];
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final newsProv = Provider.of<NewsProv>(context, listen: false);
    newsProv.fetchNews('Topstories');
  }

  Future<void> sign_out(BuildContext context) async {
    FirebaseAuth.instance.signOut().then((value) async {
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Login(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                final tween = Tween(begin: begin, end: end);
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ));
      }
      // context.go('/signin_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProv = Provider.of<NewsProv>(context);
    List<Newsmodel> newslist = newsProv.newslist;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<GreetProv>(
                      builder: (context, value, child) {
                        return Text(
                          'Welcome, ' + value.setGreet(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          sign_out(context);
                        },
                        icon: const Icon(Icons.exit_to_app))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedIndex == index
                                      ? Color.fromARGB(255, 52, 81, 105)
                                      : Colors.white,
                                  foregroundColor: selectedIndex == index
                                      ? Colors.white
                                      : Color.fromARGB(255, 52, 81, 105)),
                              onPressed: () {
                                newsProv.fetchNews(types[index]);
                                newslist = newsProv.newslist;
                                print("newslist.length ${newslist.length}");
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: index == 0
                                  ? Text(
                                      'Top Stories',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  : index == 1
                                      ? Text(
                                          'Technologies',
                                          style: TextStyle(fontSize: 15),
                                        )
                                      : Text(
                                          'Sports',
                                          style: TextStyle(fontSize: 15),
                                        )),
                          SizedBox(
                            width: 15,
                          )
                        ]);
                      },
                      itemCount: types.length,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(255, 52, 81, 105),
                    onRefresh: () async {
                      // Replace this delay with the code to be executed during refresh
                      // and return asynchronous code
                      newsProv.fetchLatestNews(types[selectedIndex]);
                      newslist = newsProv.newslist;
                      setState(() {
                        print('ho');
                      });
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: SizedBox(
                      height: 650,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        News(
                                      title: newslist[index].title.toString(),
                                      description: newslist[index]
                                          .description
                                          .toString(),
                                      imageUrl:
                                          newslist[index].imageUrl.toString(),
                                      ntime: newslist[index].ntime,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                child: Stack(children: [
                                  Image(
                                      image: NetworkImage(
                                          newslist[index].imageUrl.toString()),
                                      height: 270,
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      fit: BoxFit.cover),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //         backgroundColor:
                                  //             Color.fromARGB(255, 52, 81, 105)),
                                  //     onPressed: () {
                                  //       newsProv.fetchNews(types[index]);
                                  //       newslist = newsProv.newslist;
                                  //       print("newslist.length ${newslist.length}");
                                  //       setState(() {});
                                  //     },
                                  //     child: Text(
                                  //                 'Sports',
                                  //                 style: TextStyle(
                                  //                     color: Colors.white, fontSize: 15),
                                  //               )),
                                  Positioned(
                                    top: 140,
                                    child: Container(
                                      color: Color.fromARGB(203, 0, 0, 0),
                                      height: 210,
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newslist[index].title.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  newslist[index]
                                                      .description
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          );
                        },
                        itemCount: newslist.length,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
