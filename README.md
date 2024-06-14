# Txt to SRT converter

This script can be used to convert subtitles from Txt to SRT or VTT format.
Input time format HH:MM:SS:FF - HH:MM:SS:FF

## Convert

Run:

```
./convert-txt-srt.sh file.txt
./convert-txt-srt.sh file.txt vtt // for WEBVTT
```

This will output a `file.srt` or `file.vtt` file.

## Batch convert

To convert all files in a given folder, run:

```
./convert-all-txt-srt.sh
./convert-all-txt-srt.sh vtt // for WEBVTT
```

