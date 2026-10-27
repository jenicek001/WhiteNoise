# WhiteNoise

Generate long (default 12 h) white, pink and brown noise MP3 files to play from a
speaker's microSD/TF card, e.g. as a sleep aid for a baby. There's no phone and no
Bluetooth, so nothing can drop the connection in the middle of the night.

Originally made for the Sencor SIRIUS 2 MAXI, but the files work on any player that
reads MP3 from a card or USB stick.

## Requirements

- Linux/macOS with `bash` and `ffmpeg` (with `libmp3lame`)
  - Debian/Ubuntu: `sudo apt install ffmpeg`
  - macOS: `brew install ffmpeg`

## Usage

```bash
./make_noise.sh                 # 12 h tracks into ./out
./make_noise.sh ./out 60        # 60 s test build
```

Output:

| File            | Sound                                  |
|-----------------|----------------------------------------|
| `01_white.mp3`  | White noise: bright, hiss-like         |
| `02_pink.mp3`   | Pink noise: balanced, like steady rain |
| `03_brown.mp3`  | Brown noise: deep, like a waterfall    |

Press "next" on the speaker to switch between them. All three are loudness-matched
(about −21 LUFS), so switching tracks doesn't change the volume suddenly.

Generation streams directly from ffmpeg's noise generator into the MP3 encoder, with
no intermediate WAV. It's much faster than real time: a few minutes for all three 12 h tracks.

## Audio format

| Parameter   | Value                         | Why |
|-------------|-------------------------------|-----|
| Codec       | MP3 (libmp3lame), CBR 128 kbps | Supported by practically every card player. Noise is the hardest signal for MP3, and lower bitrates sound "watery" |
| Channels    | Mono                          | Noise has no stereo image; mono halves the data |
| Sample rate | 44.1 kHz                      | Universally supported |
| Filters     | 40 Hz highpass, 30 s fade-in, peak limiter | Removes sub-bass small speakers can't play, gives a gentle start, prevents clipping |
| Size        | ~690 MB per 12 h track         | |

## Copying to the card

1. Use a **FAT32** card (32 GB or smaller cards are FAT32 out of the box; many cheap players can't read exFAT).
2. Copy the files **one at a time, in order** (01, then 02, then 03). Simple players play files
   in the order they were written to the card, not alphabetically.
3. Safely eject (`sync`), insert into the speaker and switch it to card mode.
4. Keep the speaker **plugged into its charger** overnight, because most portable speakers' batteries won't last 12 h.

## Which noise and how loud?

- There's no solid evidence that white noise is better than pink or brown for sleep. Research on
  sleep noise in general is weak, though it does help newborns settle. Try all three and keep what works.
- Common guidance for infants: **no more than 50 dBA at the cot**, with the speaker **at least 2 m (7 ft) away**.
  Set the speaker volume accordingly; a phone sound-meter app is good enough for checking.

## License

MIT
