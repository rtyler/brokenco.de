---
layout: post
title: Jamming on Google Meet with Pulseaudio
tags:
- linux
---

For an upcoming hack week I wanted to have some live jam sessions with
colleagues on a video call. Mostly I wanted some background music we could
listen to while we hacked together, occasionally discussing our work, etc.
I don't _normally_ use Pulseaudio in anger but it seemed like the closest and
potentially simplest solution.

The biggest thing I _like_ about Pulseaudio is having independent mixer
controls for _every application_. The
[pulsemixer](https://github.com/GeorgeFilipkin/pulsemixer) tool sits in an open
terminal all day to make it easier for me to move audio levels around.

One big requirement was that I wanted to be able to make the volume in my
headphones louder than it was for other participants in the call.

Using `pacctl` I set out to solve this with:

* Create two null sinks:
  * Music
  * Playback
* Create three loopback devices:
  * Two from Music sink
  * Microphone

```
pactl load-module module-null-sink sink_name=Playback sink_properties=device.description=Stream
pactl load-module module-loopback source=Music.Monitor
pactl load-module module-loopback source=Music.monitor
pactl load-module module-combine-sink sink_name=Dualie slaves="Music,Playback" channels=2 channel_map=left,right
```

Then I:

* assigned my music to the `Music` null sink.
* Move "Music loopback" and "Microphone loopback" to the Playback sink
* Move another Music loopback to my headphones.

Finally, I select "Monitor of Stream" as the input device in the video call.


With a rhythm driving in the background, the hacking can commence!


