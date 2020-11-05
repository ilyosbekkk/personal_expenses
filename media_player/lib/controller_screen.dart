import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:media_player/audioquery.dart';
import 'package:media_player/musicplayer_bottomsheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Controller extends StatefulWidget {
  List<SongInfo> songs = new List();
  bool isFavorite = false;

  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  @override
  void initState() {
    super.initState();
    getAllArtists().then((value) {
      setState(() {
        widget.songs.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Music App"),
        ),
        body: widget.songs.length > 0
            ? ListView.builder(
                itemCount: widget.songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      playMusic(widget.songs[index].title.toString(), true,
                          widget.songs[index], widget.songs);
                    },
                    child: indvidualSong(widget.songs[index]),
                  );
                })
            : Center(
                child: Text("No music available"),
              ));
  }

  void playMusic(
      String title, bool isPlaying, SongInfo songInfo, List<SongInfo> songs) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MusicPlayer(title, isPlaying, songInfo, songs)));
  }

  Widget indvidualSong(SongInfo songInfo) {
    String formattedTitle;
    String icon = songInfo.title.toString()[0];
    String songTitle = songInfo.title.toString();
    if (songTitle.length >= 20) {
      formattedTitle = songTitle.substring(0, 15);
    } else {
      formattedTitle = songTitle;
    }
    return Card(
      elevation: 5.0,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: Colors.lightBlueAccent,
              child: Text(icon),
            ),
          ),
          Text(
            "${formattedTitle}...",
            style: Theme.of(context).textTheme.headline1,
          ),
          !widget.isFavorite
              ? Expanded(

                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isFavorite = true;
                      });
                    },
                    icon: Icon(Icons.favorite_border),
                  ),
              )
              : Expanded(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isFavorite = false;
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
              )
        ],
      ),
    );
  }
}
