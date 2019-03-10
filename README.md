# hercdet

Hercules video adapter card detection.

While debugging a particular timming problem in PCEm latest version
(10.03.2019) on the emulation of hercules video adapters, I came up with
this tiny msdos 16-bit which makes my life easier to test the timings emulated
in PCEm instead of using detection routines of games in that era. 
Instead of executing games which sometimes didn't do a good job exiting if detection of video cards fails 
and eventually crashing the machine. 
To avoid the crashes, this should be enough to test it.

## XT, AT and PS/2 I/O port addresses for Hercules

This is an extract for the relevant information used here,
the complete list of ports can be found at:
http://bochs.sourceforge.net/techspec/PORTS.LST

```
-------------------------------------------------------------------------------
03B0-03BF ----	MDA  (Monochrome Display Adapter based on 6845)

[...]

03BA	r	CRT status register	 EGA/VGA: input status 1 register
		 bit 7	 (MSD says) if this bit changes within 8000h reads then
		  bit 6-4 = 000 = adapter is Hercules or compatible
			    001 = adapter is Hercules+
			    101 = adapter is Hercules InColor
				  else: adapter is unknown
		 bit 3	 black/white video
		 bit 2-1 reserved
		 bit 0	 horizontal drive

[...]

```


## Build

This program compile with Turbo Assembler Version 4.1
```
c:\hercdet> build.bat
```


