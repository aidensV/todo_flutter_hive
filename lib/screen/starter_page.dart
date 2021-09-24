import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/database/profile.dart';
import 'package:myapp/database/todo.dart';
import 'package:myapp/screen/home.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({Key? key}) : super(key: key);

  @override
  _StarterPageState createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  TextEditingController nameController = TextEditingController();
  void getProfile() async {
    final box = await Hive.openBox<Profile>('profile');
    if (box.values.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(180),
                          bottomRight: Radius.circular(280))),
                ),
                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 140),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Image.network(
                        'https://download.logo.wine/logo/Adobe_XD/Adobe_XD-Logo.wine.png'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Text("Start enjoying a more organized life",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              "Plan, organize, track, in one visual, collaborative space",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: () async {
                final box = await Hive.openBox<Profile>('profile');

                if (box.values.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "What's Your Name?",
                            style: TextStyle(color: Colors.blue),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "name"),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text("Save"),
                                  onPressed: () async {
                                    Profile profile =
                                        new Profile(name: nameController.text);
                                    var box =
                                        await Hive.openBox<Profile>('profile');
                                    box.add(profile);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Get started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
