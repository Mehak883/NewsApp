// ignore_for_file: avoid_print, file_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Models/Model.dart';
import 'package:newsapp/Providers/GreetProv.dart';
import 'package:newsapp/Providers/NewsProv.dart';
import 'package:newsapp/Screens/LoginScreens/Login.dart';
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
  // String greet = '';
  // void _updateGreetingMessage() {
  //   final hour = DateTime.now().hour;
  //   setState(() {
  //     if (hour < 12) {
  //       greet = 'Good Morning';
  //     } else if (hour < 17) {
  //       greet = 'Good Afternoon';
  //     } else {
  //       greet = 'Good Evening';
  //     }
  //   });
  // }
  String uname = '';

  @override
  void initState() {
    super.initState();
    final newsProv = Provider.of<NewsProv>(context, listen: false);
    final greetProv = Provider.of<GreetProv>(context, listen: false);
    greetProv.setGreet();
    // greetProv.userInfor().then((value) => uname = value);
    newsProv.fetchNews('Topstories');
    fetchUserInfo();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      print('hi');
      greetProv.setGreet();
    });
  }

  Future<void> fetchUserInfo() async {
    String name = '';
    final greetProv = Provider.of<GreetProv>(context, listen: false);
    name = await greetProv.userInfor();
    setState(() {
      uname = name;
    });
  }

  // ignore: non_constant_identifier_names
  Future<void> sign_out(BuildContext context) async {
    FirebaseAuth.instance.signOut().then((value) async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
      // context.go('/signin_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProv = Provider.of<NewsProv>(context);
    final greetProv = Provider.of<GreetProv>(context, listen: false);
    Future<String> convFutureString() async {
      String name = '';
      await greetProv.userInfor().then((value) {
        name = value;
      });
      print('name : $name');
      return name;
    }

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
                    Text(
                      '${greetProv.greet}, ${uname[0].toUpperCase()}${uname.substring(1)}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
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
                                      ? const Color.fromARGB(255, 52, 81, 105)
                                      : Colors.white,
                                  foregroundColor: selectedIndex == index
                                      ? Colors.white
                                      : const Color.fromARGB(255, 52, 81, 105)),
                              onPressed: () async {
                                newsProv.fetchNews(types[index]);
                                newslist = newsProv.newslist;
                                print("newslist.length ${newslist.length}");
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: index == 0
                                  ? const Text(
                                      'Top Stories',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  : index == 1
                                      ? const Text(
                                          'Technologies',
                                          style: TextStyle(fontSize: 15),
                                        )
                                      : const Text(
                                          'Sports',
                                          style: TextStyle(fontSize: 15),
                                        )),
                          const SizedBox(
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
                    backgroundColor: const Color.fromARGB(255, 52, 81, 105),
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
                              child: Stack(children: [
                                Image(
                                    image: NetworkImage(
                                        newslist[index].imageUrl.toString()),
                                    height: 270,
                                    width:
                                        MediaQuery.of(context).size.width - 10,
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
                                    color: const Color.fromARGB(203, 0, 0, 0),
                                    height: 210,
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newslist[index].title.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                newslist[index]
                                                    .description
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]),
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
