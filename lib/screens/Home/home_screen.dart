import 'package:english_learning/screens/Levels/level_one.dart';
import 'package:english_learning/screens/Levels/level_three.dart';
import 'package:english_learning/screens/Levels/level_two.dart';
import 'package:english_learning/services/hive_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int level = 0;

  void getLevel() {
    /// Yerel veritabanından kullanıcının seviyesi getiriliyor
    level = HiveService().getLevel();
    print('level: $level');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Learning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LevelOne())).then((value) => getLevel());
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level 1', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Spacer(),

                    /// Kullanıcının seviyesi 1'den küçükse kilidin görünmesi sağlanıyor
                    if (level < 1) ...[
                      Icon(Icons.lock),
                    ] else ...[
                      Icon(Icons.play_arrow),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (level >= 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LevelTwo())).then((value) => getLevel());
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level 2', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Spacer(),

                    /// Kullanıcının seviyesi 2'den küçükse kilidin görünmesi sağlanıyor
                    if (level < 2) ...[
                      Icon(Icons.lock),
                    ] else ...[
                      Icon(Icons.play_arrow),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (level >= 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LevelThree())).then((value) => getLevel());
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level 3', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Spacer(),

                    /// Kullanıcının seviyesi 3'den küçükse kilidin görünmesi sağlanıyor
                    if (level < 3) ...[
                      Icon(Icons.lock),
                    ] else ...[
                      Icon(Icons.play_arrow),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
