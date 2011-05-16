--- 
layout: post
title: Building a game for ET. Day 1 with Pygame
tags: 
- python
nodeid: 266
created: 1266140124
---
Earlier this week I was checking out <a id="aptureLink_8JIIdIavnW" href="http://en.wikipedia.org/wiki/Pygame">Pygame</a>, pondering what I could possibly build with it that could keep me motivated enough to finish it. Motivation would like be the primary problem for me with any amount of game programming; I'm not a gamer, I don't harbor a dislike of games, they're just not something I typically spend time playing (I do like to play "haggard late night open-source hacker" though, that's a fun one). Friday night I stumbled across an idea, ET likes to play (casual) games, perhaps we could write a game together; ask any engineer at EA or Ubisoft, there's nothing more romantic than working on a game.

Talking over the idea with ET on the ride home from the office, we talked about creating a typing-oriented game and started to brainstorm. The tricky aspect of a typing-oriented game is you have to walk the fine line of "educational gaming", that is to say, the game's goal is **not** to teach the player how to type. That sucks. Contrasted to some other games where the means of progressing in some games is by solving a puzzle, killing noobs in others, in this game we wanted the player to progress through levels/situations with their typing ability (ET finds this fun, we do not have this in common).

Over pizza we discussed more about how the levels would work, I decided that I wanted to use stories/articles instead of random words for the "content" of the game. We settled on a couple fundamental concepts: the player would earn coins by correctly completing a words as the scrolled from right to left (similar to a ticker tape), they would lose coins if they made a mistake or could not keep up. After a player completed a level (i.e. a "story") they would find themselves in a "store" of sorts, where they could purchase "tools" for future levels with their coins. The tools we decided would be a *very* important, as the player reached their upper bound of typing speed the utility of these various tools would necessary as a means of strategically conquering the level. One of the few things we didn't particularly cover was the "end game", whether the player would simply play increasingly more difficult levels (a la <a id="aptureLink_S4eypmdIVi" href="http://en.wikipedia.org/wiki/Tetris">Tetris</a>) or if they could actually "beat" the game. With at least the basics of the concept sketched out, it was time to start writing *some* code.


### Starting with Pygame
It's **incredibly** important to mention that I've *never* programmed a game before. *Never-ever*. From my work with network programming I was already familiar with the concept of the run-loop that's pretty core to Pygame, but I had never really made use of any to animate objects on the screen or deal with handling any kind of events from mouse movements to key presses, etc. Fortunately I'm already a professional Python developer, so writing code wasn't the difficult part so much as laying it out. Orienting things into classes to handle separate components such as animating text (which is a painful in Pygame, in my opinion) to keeping track of user-input.

Animating text across the screen wasn't particularly difficult, with Pygame you first create your primary "surface" (i.e. the window) and then you can render things onto that surface. With text, you end up rendering a surface which contains your text, "hello world" which you then place onto the primary surface. Easy peasy thus far:
<code type="python">
    import pygame
    surface = pygame.display.set_mode((640, 680), pygame.HWSURFACE | pygame.DOUBLEBUF)
    font = pygame.font.SysFont('Courier', 42)
    ### render(text, antialias, rgb color tuple
    font_surface = font.render('hello world', 0, (0, 0, 0)) 
    ### draw `font_surface` onto `surface` at (x=0, y=0)
    start_x, start_y = 0, 0
    surface.blit(font_surface, (start_x, start_y))
    while True:
         ### Holy runloop batman
         pygame.display.update()
</code>

That was fun, I now have "hello world" rendered onto my screen, now to animate I suppose I'll just render `font_surface` a little further right every iteration of the runloop, i.e.
<code type="python">
    while True:
         ### Holy runloop batman
         surface.blit(font_surface, (start_x, start_y))
         start_x += 0.5
         pygame.display.update()
</code>
This blurs the text however, so I then changed to:
<code type="python">
    while True:
         ### Holy runloop batman
         surface.blit(font_surface, (start_x, start_y))
         surface.fill((0, 0, 0))
         start_x += 0.5
         pygame.display.update()
</code>
This will cause the (primary) surface to be repainted (washed over) every iteration of the runloop ensuring that the text will properly animate, drawing the text in one spot, wiping the surface then drawing it slightly further to the left, resulting in the scrolling animation. All's fine and good until you determine that you want to have *other* elements on the screen and you also don't want to redraw them every time around the carousel. I then discovered how to "fill" just one particular rectangle on the surface, i.e. the rectangle behind the text:
<code type="python">
    text_w, text_h = font.size('hello world')
    while True:
         ### Holy runloop batman
         surface.blit(font_surface, (start_x, start_y))
         surface.fill((0, 0, 0), rect=pygame.Rect(start_x, start_y, text_w, text_h))
         start_x += 0.5
         pygame.display.update()
</code>

Once I was able to get text properly scrolling across the screen, the rest of the afternoon of hacking was far easier. My confidence in my ability to grok Pygame in order to do what I wanted. I then set forth organizing my code into some logical classes, for example I created a `LetterSpool` class which would record the user's progress through the current word, rendering it at the bottom-center of the screen and firing an event when the user hit the space bar (denoting the word "complete"), additionally I wrapped my text animation code into `AnimatedWord` so I could easily string words together to scroll across the screen in conjunction similar to a textual screensaver.

Not a whole lot more to write about with regards to my progress today, hooked up some music and basic sound effects which was trivial after looking at some sample code. Next I need to start addressing some more fundamentals for user-interaction: scoring and level-changing.


You can track the progress of the game "Typy" (pronounced: `typey`) [on GitHub](http://github.com/rtyler/typy)

<center><img src="http://agentdero.cachefly.net/scratch/typy_day1.png"/></center>
