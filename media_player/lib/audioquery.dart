///you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

final FlutterAudioQuery audioQuery = FlutterAudioQuery();

Future<List<SongInfo>> getAllArtists() async {
  List<SongInfo> songs = await audioQuery.getSongs();
  return songs;
}
