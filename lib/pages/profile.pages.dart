import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> users;

  @override
  void initState() {
    super.initState();
    users = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<User>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                            child: Material(
                                color: Colors.transparent,
                                child: Image.network(snapshot.data!.img))),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            snapshot.data!.nama,
                            style: GoogleFonts.ubuntu(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(snapshot.data!.blog,
                            style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 27, 166, 197),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text('Hello There!',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 5,
                        ),
                        Image.network(
                          'https://img.icons8.com/fluency/2x/instagram-new.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          "@abbysudrajatt",
                          style: GoogleFonts.ubuntu(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          'https://img.icons8.com/color/2x/whatsapp.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          "082225270951",
                          style: GoogleFonts.ubuntu(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class User {
  String img;
  String nama;
  String location;
  String blog;
  String company;

  User(
      {required this.img,
      required this.nama,
      required this.location,
      required this.blog,
      required this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        img: json['avatar_url'],
        nama: json['name'],
        location: json['location'],
        blog: json['blog'],
        company: json['company']);
  }
}

Future<User> fetchUser() async {
  String api = 'https://api.github.com/users/Pramuditapss';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
