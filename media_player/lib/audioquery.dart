///you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

final FlutterAudioQuery audioQuery = FlutterAudioQuery();

Future<List<SongInfo>> getAllArtists() async {
  List<SongInfo> songs = await audioQuery.getSongs();
  return songs;
}
//file:///storage/121B-0C1C/Android/data/com.android.chrome/files/Download/Javohir_Sodiqov_-_Baby_(uzhits.net).mp3
