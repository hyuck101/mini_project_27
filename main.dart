import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_project27/auth_service.dart';
import 'package:mini_project27/board.dart';
import 'package:mini_project27/board_service.dart';
import 'package:mini_project27/login.dart';
import 'package:mini_project27/news.dart';
import 'package:mini_project27/newsservice.dart';
import 'package:mini_project27/search.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(); // firebase 앱 시작

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BoardService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // 홈페이지 보여주기
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  int currentIndex = 0;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: '경제',
    ),
    Tab(
      text: '정치',
    ),
    Tab(
      text: '국제',
    ),
    Tab(
      text: '스포츠',
    ),
    Tab(
      text: '연예',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this)
      ..addListener(() {
        context
            .read<NewsService>()
            .getNewsData('${myTabs[_tabController.index].text}');
      });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsService>(
      builder: (context, newsService, child) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Daily News',
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // 로그아웃
                      if (AuthService().currentUser() != null) {
                        context.read<AuthService>().signOut();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃 되었습니다'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃 상태입니다'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.blueAccent),
                    ))
              ],
              bottom: PreferredSize(
                  child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      indicatorColor: Colors.blueAccent,
                      tabs: myTabs),
                  preferredSize: Size(MediaQuery.of(context).size.width, 50)),
            ),
            body: TabBarView(
              controller: _tabController,
              children: myTabs.map(
                (Tab tab) {
                  return ListView.separated(
                    itemCount: newsService.newsList.length,
                    itemBuilder: (context, index) {
                      if (newsService.newsList.isNotEmpty) {
                        News news = newsService.newsList[index];
                        return ListTile(
                          onTap: () {
                            launch(news.link);
                          },
                          title: Text(news.title),
                          subtitle: Text(news.time),
                          leading: Text('${index + 1}'),
                        );
                      } else {
                        return Container();
                      }
                    },
                    separatorBuilder: (context, index) {
                      if (newsService.newsList.isNotEmpty) {
                        return Divider(
                          height: 9,
                          color: Colors.black,
                        );
                      } else {
                        return Divider(height: 9, color: Colors.transparent);
                      }
                    },
                  );
                },
              ).toList(),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => Login()),
                                );
                              },
                              child: CircleAvatar(
                                radius: 60,
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(AuthService().currentUser() == null
                                ? '아이콘을 클릭하여 로그인 해주세요'
                                : '${AuthService().currentUser()!.email}님 로그인 되어 있습니다!')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(),
                  ListTile(
                    title: Text('뉴스검색'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () {
                      if (AuthService().currentUser() != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Search()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그인이 필요합니다'),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                      title: Text('자유게시판'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {
                        if (AuthService().currentUser() != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Board()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('로그인이 필요합니다'),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
