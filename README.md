# Columns

_Circa 1992_

A [Columns](http://en.wikipedia.org/wiki/Columns_%28video_game%29) clone in 68000 assembly, for the [Atari ST](http://en.wikipedia.org/wiki/Atari_ST).

My initial intent was to fit it into the bootsector of a floppy disk (without any compression), but I overran the 420 or so free bytes I would have in the bootsector. I therefore ended up adding a bunch of text, graphics, and sound effects; and intentionally overran the limit even further.

The code could still run from the bootsector with a bit of cheating: I was storing the overrun in the [FAT](http://en.wikipedia.org/wiki/File_Allocation_Table#FAT12) backup and therefore keeping the disk operational until a write operation on the disk would overwrite the FAT backup and screw up the game.

![Screenshot](../screenshots/screenshot.png?raw=true)

[Video](https://www.youtube.com/watch?v=dGGP7PIcxUg) (A little choppy due to the sluggish video capture of the emulator)
