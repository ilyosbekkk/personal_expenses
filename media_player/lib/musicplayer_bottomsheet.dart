import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicPlayer extends StatefulWidget {
  final title;
  final SongInfo songInfo;
  bool isPlaying;

  MusicPlayer(this.title, this.isPlaying, this.songInfo);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    super.initState();
    playMusic(widget.songInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
            child: Text(
              widget.songInfo.artist,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.skip_previous),
                ),
                widget.isPlaying
                    ? IconButton(
                        onPressed: () {
                          setPlayCondition();
                        },
                        icon: Icon(Icons.pause))
                    : IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          setPlayCondition();
                        },
                      ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.skip_next),
                )
              ],
            ),
          ),
          Container(
            child: Slider(
              onChanged: null,
              value: 1,
            ),
          )
        ],
      ),
    ));
  }

  void setPlayCondition() {
    setState(() {
      widget.isPlaying = !widget.isPlaying;
    });
  }

  void playMusic(SongInfo info) async {
    AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    print(await audioPlayer.getCurrentPosition());
    int result = await audioPlayer.play(info.filePath, isLocal: true);
    print(result);
  }
}
