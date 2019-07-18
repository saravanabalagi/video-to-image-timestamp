# video-to-image
A simple shell script to pulverise a video into PNGs which can then be used in slam systems like [ORB SLAM](https://github.com/raulmur/ORB_SLAM2). This also creates a `.txt` file with timestamp and filename of each file in separate lines similar to that of TUMs `rgb.txt`

```
1305031102.175304 rgb/1305031102.175304.png
1305031102.211214 rgb/1305031102.211214.png
1305031102.243211 rgb/1305031102.243211.png
1305031102.275326 rgb/1305031102.275326.png
1305031102.311267 rgb/1305031102.311267.png
```

## Dependencies

1. ffprobe
1. ffmpeg

## Usage

Place your video file in the same place as [video_processor](video_processor.sh) script and then execute in your terminal
```sh
sh video_processor.sh your_video_file
```

## Options:

These options can be configured interactively once the script is executing:

1. Output folder name
2. Resize
3. Rotate
4. Specify fps

## License

Please see the [license](LICENSE) file
