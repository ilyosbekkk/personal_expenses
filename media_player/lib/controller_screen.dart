import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:media_player/audioquery.dart';
import 'package:media_player/musicplayer_bottomsheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Controller extends StatefulWidget {
  List<SongInfo> songs = new List();

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
        body: ListView.separated(
            itemCount: widget.songs.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  print(widget.songs[index].filePath.toString());
                  openCupertinoModalBottomSheet(
                      widget.songs[index].title.toString(), true,  widget.songs[index]);
                },
                child: Text(
                  widget.songs[index].title.toString(),
                  style: Theme.of(context).textTheme.headline1,
                ),
              );
            }));
  }

  void openCupertinoModalBottomSheet(String title,  bool isPlaying, SongInfo info ) async {

    return await showCupertinoModalBottomSheet(
        context: context,
        builder: (context, scrollController) => MusicPlayer(title, isPlaying,  info));
  }
}
