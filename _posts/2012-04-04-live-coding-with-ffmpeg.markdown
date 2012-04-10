---
layout: post
title: Live Coding with ffmpeg and justin.tv
tags:
- programming
- livecoding
- justintv
---

Recently I've been experimenting with operating a live coding stream of my
desktop. What this means in practice is that I focus on a single project or set
of tasks for an hour or two, while streaming everything I do to my [channel on
justin.tv](http://justin.tv/agentdero).


Here's a boring demonstration:

<center>
<object type="application/x-shockwave-flash" height="300" width="400" id="clip_embed_player_flash" data="http://www.justin.tv/widgets/archive_embed_player.swf" bgcolor="#000000"><param name="movie" value="http://www.justin.tv/widgets/archive_embed_player.swf" /><param name="allowScriptAccess" value="always" /><param name="allowNetworking" value="all" /><param name="allowFullScreen" value="true" /><param name="flashvars" value="auto_play=false&start_volume=25&title=Demonstration of live coding&channel=agentdero&archive_id=313873687" /></object><br /><a href="http://www.justin.tv/agentdero#r=-rid-&amp;s=em" class="trk" style="padding:2px 0px 4px; display:block; width: 320px; font-weight:normal; font-size:10px; text-decoration:underline; text-align:center;">Watch live video from Live coding with @agentdero on Justin.tv</a>
</center>

I'll save my thoughts on how the experiment is going for a later blog post, in
this post I just wanted to share the **how**.


First I use this `~/bin/screenstream` script:

    #!/bin/sh -xe

    INFO=$(xwininfo -frame)
    API_KEY="YOUR_API_KEY_GOES_HERE"

    WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' | grep -oEe '[0-9]+x[0-9]+')
    WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' | grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/\+/,/' )
    FPS="15"

    INRES='1680x1010'
    OUTRES='1280x720'

    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+$WIN_XY \
        -f alsa -ac 2 -i default -vcodec libx264  -s "$OUTRES"  \
        -acodec libmp3lame -ab 128k -ar 44100 -threads 0 \
        -f flv "rtmp://live.justin.tv/app/$API_KEY"

There's a couple important things to mention about this:

* The `xwininfo` invocation just gives me a cross-hairs cursor so I can select which window area I want to record. This doesn't technically restrict `ffmpeg(1)` to just that window, rather it just grabs the offset from the window and uses those.
* The segment: `-f alsa -ac 2 -i default` pertains to the audio input. According to `arecord -L`, the pulse audio sink I should use is called "default", on some machines it might be called "pulse", your mileage may vary.
* I use the `pavucontrol` (GUI) tool to direct my audio out to the pulseaudio input, this allows me to share what I'm listening to with whoever is watching the stream.
* You'll notice the `$INRES` and `$OUTRES` parameters, I am techically live-resizing the video on the fly, which takes up a lot of CPU power, you may or may not want to do this depending on your machine speed, size of your screen and the amount of desktop space you want to stream.


That's about all there is too it, I wish I could either take credit for the
script or at least attribute it, but I can do neither because I found it on a
forum some where and then quickly lost the link. Whoops.
