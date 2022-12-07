import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int item;
  final String nama;
  const DetailPage({Key? key, required this.item, required this.nama})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<KarakterDetail> karDetail;

  @override
  void initState() {
    super.initState();
    karDetail = fetchDetails(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.nama,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<KarakterDetail>(
          future: karDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        width: 250,
                        height: 400,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(1, 1),
                              )
                            ],
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 25, 78, 110))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        snapshot.data!.imgUrl,
                                        width: 240,
                                        height: 240,
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://img.icons8.com/material/512/gender.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(snapshot.data!.gender,
                                      style: GoogleFonts.ubuntu(fontSize: 15)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://img.icons8.com/material/512/like.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(snapshot.data!.status,
                                      style: GoogleFonts.ubuntu(fontSize: 15)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                bottom: 5,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://img.icons8.com/material/512/standing-man.png',
                                    width: 22,
                                    height: 22,
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Text(snapshot.data!.species,
                                      style: GoogleFonts.ubuntu(fontSize: 15)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://img.icons8.com/material/512/marker.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        snapshot.data!.location.nama,
                                        style: GoogleFonts.ubuntu(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 25, 78, 110),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(snapshot.data!.nama,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ))),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

class Location {
  String nama;

  Location({required this.nama});

  factory Location.fromJson(json) {
    return Location(nama: json['name'] ?? 'Unknown');
  }
}

class KarakterDetail {
  String imgUrl;
  String nama;
  int id;
  String species;
  String gender;
  String status;
  Location location;

  KarakterDetail({
    required this.imgUrl,
    required this.nama,
    required this.id,
    required this.species,
    required this.gender,
    required this.status,
    required this.location,
  });

  factory KarakterDetail.fromJson(json) {
    return KarakterDetail(
        imgUrl: json['image'],
        nama: json['name'],
        id: json['id'],
        species: json['species'] ?? 'Unknown',
        gender: json['gender'] ?? 'Unknown',
        status: json['status'] ?? 'Unknown',
        location: Location.fromJson(json["location"]));
  }
}

Future<KarakterDetail> fetchDetails(id) async {
  var response = await http.get(
    Uri.parse('https://rickandmortyapi.com/api/character/$id'),
  );

  if (response.statusCode == 200) {
    return KarakterDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
