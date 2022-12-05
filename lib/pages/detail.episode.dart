import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DetailEpisode extends StatefulWidget {
  final int item;
  final String nama;
  const DetailEpisode({Key? key, required this.item, required this.nama})
      : super(key: key);

  @override
  _DetailEpisodeState createState() => _DetailEpisodeState();
}

class _DetailEpisodeState extends State<DetailEpisode> {
  late Future<EpisodeDetail> epsDetail;

  @override
  void initState() {
    super.initState();
    epsDetail = fetchDetails(widget.item);
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
            child: FutureBuilder<EpisodeDetail>(
          future: epsDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(80),
                child: Card(
                  elevation: 15,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!.episode,
                              style: GoogleFonts.ubuntu(fontSize: 15),
                            ),
                            Text(
                              snapshot.data!.release,
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/episode.png'),
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 25, 78, 110)),
                        child: Text('\"' + snapshot.data!.nama + '\"',
                            style: GoogleFonts.ubuntu(
                                fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ));
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

class EpisodeDetail {
  String release;
  String episode;
  String nama;
  int id;

  EpisodeDetail(
      {required this.release,
      required this.episode,
      required this.nama,
      required this.id});

  factory EpisodeDetail.fromJson(json) {
    return EpisodeDetail(
        release: json['air_date'],
        episode: json['episode'],
        nama: json['name'],
        id: json['id']);
  }
}

Future<EpisodeDetail> fetchDetails(id) async {
  var response = await http.get(
    Uri.parse('https://rickandmortyapi.com/api/episode/$id'),
  );

  if (response.statusCode == 200) {
    return EpisodeDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
