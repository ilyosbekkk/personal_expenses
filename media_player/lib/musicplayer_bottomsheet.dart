import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:volume/volume.dart';

class MusicPlayer extends StatefulWidget {
  final title;
  double current;
  SongInfo songInfo;
  bool isPlaying = true;
  AudioPlayer audioPlayer;
  int maxVal, currentVal;
  bool isMuted = false;
  AudioCache audioCache;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  final List<SongInfo> songs;

  MusicPlayer(this.title, this.isPlaying, this.songInfo, this.songs);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //region overrides
  @override
  void initState() {
    super.initState();
    playMusic(widget.songInfo);
    widget.current = 15;
    initAudioStreamType();
    updateVolumes();
  }

  @override
  void dispose() {
    super.dispose();
    stopMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Playing"),
        ),
        body: Container(
          child: playArea(),
        ));
  }

  //endregion

  //region UI part
  Widget playArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0,  bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/music.jpg"),
          ),
        ),

        Container(
          child: Text(
            widget.songInfo.title,
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
            children: [
              Expanded(
                child: Slider.adaptive(
                    onChanged: (double value) {
                      setState(() {
                        seekToSecond(value.toInt());
                      });
                    },
                    value: widget._position.inSeconds.toDouble(),
                    min: 0.0,
                    max: (widget._duration.inSeconds.toDouble())),
              ),
              timeCalculation(),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !widget.isMuted
                  ? IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        muteUnmuteVolume();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.volume_off),
                      onPressed: () {
                        muteUnmuteVolume();
                      },
                    ),
              Slider.adaptive(
                onChanged: !widget.isMuted
                    ? (double value) {
                        setState(() {
                          widget.current = value;
                        });
                        if (value == 0)
                          setState(() {
                            widget.isMuted = true;
                          });
                        setVol(value.toInt());
                      }
                    : null,
                label: widget.current.round().toString(),
                min: 0,
                max: 15,
                value: widget.current,
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.skip_previous),
                ),
              ),
              widget.isPlaying
                  ? CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          setPlayCondition();
                        },
                        icon: Icon(Icons.pause)),
                  )
                  : CircleAvatar(
                    child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          setPlayCondition();
                        },
                      ),
                  ),
              CircleAvatar(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.skip_next),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

//endregion

  //region  pause/resume
  void setPlayCondition() async {
    setState(() {
      if (widget.isPlaying)
        widget.audioPlayer.pause();
      else
        widget.audioPlayer.resume();
    });
    setState(() {
      widget.isPlaying = !widget.isPlaying;
    });
  }

  //endregion

  //region play music
  void playMusic(SongInfo info) async {
    widget.audioPlayer = new AudioPlayer();
    int result = await widget.audioPlayer.play(info.filePath, isLocal: true);

    /* TODO onDurationChnaged onAudioPositionChanged must be used instead of durationHandler and positionHandler */
    widget.audioPlayer.durationHandler = (d) {
      setState(() {
        widget._duration = d;
      });
    };
    widget.audioPlayer.positionHandler = (p) {
      print(p.inSeconds);
      setState(() {
        widget._position = p;
      });
      nextTrack();
    };
  }

  //endregion

  //region stop music
  Future<void> stopMusic() async {
    await widget.audioPlayer.stop();
  }

  //endregion

  //region get duration
  Future<int> getDuration(AudioPlayer audioPlayer) async {
    return await audioPlayer.getDuration();
  }

  //endregion

  //region initalize audiostreamtype
  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  //endregion

  //region set volume
  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: ShowVolumeUI.SHOW);
  }

  //endregion

  //region update_volume
  updateVolumes() async {
    // get Max Volume
    widget.maxVal = await Volume.getMaxVol;
    print(widget.maxVal);
    // get Current Volume
    widget.currentVal = await Volume.getVol;
    setState(() {});
  }

  //endregion00

  //region mute/unmute
  void muteUnmuteVolume() async {
    if (await Volume.getVol == 0) {
      await Volume.setVol(widget.current.toInt(),
          showVolumeUI: ShowVolumeUI.SHOW);
      setState(() {
        widget.isMuted = false;
      });
    } else {
      await Volume.setVol(0, showVolumeUI: ShowVolumeUI.SHOW);
      setState(() {
        widget.isMuted = true;
      });
    }
  }

  //endregion

  //region seek new position
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    setState(() {
      widget.audioPlayer.seek(newDuration);
    });
  }

//endregion

  //region next_track
  void nextTrack() async {
    if (widget._position.inSeconds == widget._duration.inSeconds) {
      int i = widget.songs.indexOf(widget.songInfo) + 1;
      if (i < widget.songs.length) {
        int result = await widget.audioPlayer
            .play(widget.songs[i].filePath, isLocal: true);
        setState(() {
          widget.songInfo = widget.songs[i];
        });
      } else {
        print("end of the tracks");
      }
    }
  }

//endregion

  //region timeCalculation

  Widget timeCalculation() {
    int mins, seks;
    String zero_min = "", zero_sek = "";

    mins = widget._position.inSeconds ~/ 60;
    if (mins == 0)
      seks = widget._position.inSeconds % 60;
    else
      seks = widget._position.inSeconds % (mins * 60);

    if (mins < 10) zero_min = "0";
    if (seks < 10) zero_sek = "0";

    return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text("$zero_min$mins:$zero_sek$seks"));
  }
//endregion

}
