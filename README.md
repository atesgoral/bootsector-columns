# Columns

_Circa 1992_

A [Columns](http://en.wikipedia.org/wiki/Columns_%28video_game%29) clone in 68000 assembly, for Atari ST.

My initial intent was to fit it into the bootsector (without any compression), but I overran the 420 or so bytes I would have in the bootsector. I therefore ended up adding a bunch of text, graphics, and sound effects; and intentionally overran the limit even further.

The code would still run from the bootsector with a bit of cheating: I was storing the overrun in the backup FAT table and therefore keeping the disk operational (until a write operation on the disk would overwrite the backup FAT table and screw up the game code).

![Screenshot](../screenshots/screenshot.png?raw=true)

[Video](https://www.youtube.com/watch?v=dGGP7PIcxUg) (A little choppy due to the sluggish video capture of the emulator)
