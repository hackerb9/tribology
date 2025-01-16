# The Trouble With (amateur) Tribology

This repository is for investigating how floppy disks wear down
so that the hobbyists, curators, and retro-computer archaeologists
can keep these beasts from the dawn of the computer-age alive
as best they can with what materials are now available.

## Motivation

Currently there is a lack of 
information about the correct replacement for the felt 
pressure pad seen in single-sided disk drives used in
early microcomputers. The pad pushes 
the rotating diskette against the read/write head
and there is a possibility that using the wrong material can lead
to a disk wearing out prematurely, especially if they 
are used as "flippy" disks.[^1] 

[^1]: "Flippy disks" are disks that have a write-protect hole punched in them by 
the end user so that they can be flipped over and both sides used 
in a single-sided drive. Some pundits claim that
flippy disks will 
wear out the head because the disk will rotate backwards, spewing
out the accumulated particles trapped in the filter material.

At the time the drives were made (late 1970s to early 1980s), 
professional research into the  wear properties was limited
because floppy disks were abundant and one could just buy
replacement pads from the manufacturer. (Shugart recommendeded
doing so every 10,000 hours, if I recall correctly). 

There are plenty of anecdotal stories of substitute materials 
people have used that "work" to allow the drive to read and write,
but no information about which materials cause the least damage to magnetic media.

The hope is that by releasing a program which can make testing
easier, those who care about such things will be inspired to
run tests and share the results. As the most commonly available single-sided
drive was the Drive II used in the Apple II line of computers, [this
program](TRIBOLOGY.bas) is written in Applesoft BASIC for a system running 
Apple's DOS 3.3.

## Usage

In order to test a component, use the TRIBOLOGY TRIAL program which
prompts for a track to move the head to and then cycles around on it
forever, perhaps scraping off the magnetic material and etching a ring
into the diskette. 

An ideal test will run for 7 days straight. (Shugart says there should be
no damage to the media from the pad or head after 3 × 10⁶ revolutions). 
However, visible evidence of damage has been appearing in less than 24 hours.


## Limitations

* The program attempts to calculate elapsed wall time but it is not very
accurate, so it's better to use an external clock when possible. For reasons
not clear to me, the speed of my timing loop depends upon whether
it is run automatically as the Apple II "HELLO" program or from the prompt.

* The best metric for evaluation is not yet clear. Perhaps the ideal would be for the test rig to automatically compare the signal level on the track before and after the test. However, the disk controller does not make that information available to the Apple II and so multimeter or oscilloscope may be necessary. For now, visual estimates are being used along with minimal verification that the data has not been corrupted.

## Test results

### 0: Old (original?) felt pad in a Drive II

| | |
|-----|-----|
|Origin| Likely originally shipped with the Apple Drive II |
| Material | Synthetic (melts instead of burning) |
| Filament length | Short | 
| Density | Firmly packed, coloration is yellowish brown, probably from age. |
| Notes| The floppy disk used in this test was not new, unlike the other tests. This also used a different drive mechanism.| 

#### Trial 0-A

| | |
|-|-|
| Test duration | >24 hours |
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 12 |
| Test summary | **Pass** |

Results: No noticeable difference. However, concentric rings at every track are visible under a microscope, so perhaps this floppy has already been worn down? 


### 1: Felt Pad: Punched from self stick felt pad

| | |
|-----|-----|
|Origin| unknown (gift from deramp5113) |
| Material | Synthetic (melts instead of burning) |
| Filament length | Longer than original | 
| Density | Loosely packed compared to original, but that may be because the original has been used for decades. |
| Notes| This pad had fragments of dried glue which was removed under a microscope before testing. | 

#### Trial 1-A

| | |
|-|-|
| Test duration | >24 hours |
| Testing method | Apple II attempting to boot a fresh disk |
| Track # (of 40) | 0 (outermost) |
| Test summary | **Fail** |

Results: Track 0 has a black ring on the side facing the felt. That ring has data as the other side of the disk was formatted before the test, but it does not appear to have been affected at all. 

#### Trial 1-B

This is the same felt pad as in Trial 1-A. 

| | |
|-|-|
| Test duration | >24 hours |
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 22 |
| Test summary | **Pass** |

There do appear to be light etch marks visible only when held to the light, but they are on side A, which is touching the head, not the felt. These did not occur in Trial 1-A. Could the felt be pushing too hard? Could it be a density issue? Or is it a problem with this drive's head? 

#### Trial 1-C


| | |
|-|-|
| Test duration | 12 hours |
This is the same felt pad as in Trial 1-B, but after being removed, examined under a microscope, and had the top layer and excess filaments trimmed off. The disk was the same from Trial 1-B since no marks had been left on the felt side. The drive head was also examined and cleaned. 
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 17 |
| Test summary | **Pass** |

No marks on felt side. No apparent new marks on head side.

### 2: Second Felt Pad: Punched from self stick felt pad

| | |
|-----|-----|
|Origin| unknown (gift from deramp5113) |
| Material | Synthetic (melts instead of burning) |
| Filament length | Longer than original | 
| Density | Loosely packed compared to original, but that may be because the original has been used for decades. |
| Notes| This new pad is from a second batch sent to me by deramp; the glue on it was not dried out. The same drive mechanism was used as in the other tests; only the felt pad and its plastic holder were replaced.| 

#### Trial 2-A

| | |
|-|-|
| Test duration | 12 hours |
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 30 |
| Test summary | **Fail** |

Results: Track 30 has a faint, light ring on the side facing the felt. On the reverse (head) side, there is a prominent groove at track 30 which appears dark or light depending upon the angle of the light. 



### 3: Old (original?) felt pad in a Drive II

| | |
|-----|-----|
|Origin| Likely originally shipped with the Apple Drive II |
| Material | Synthetic (melts instead of burning) |
| Filament length | Short | 
| Density | Firmly packed, coloration is yellowish brown, probably from age. |
| Notes| This uses the same drive mechanism as the previous tests, but with a felt pad taken from a different drive. Unlike test 0, the floppy tested had never been used before.| 

#### Trial 3-A

| | |
|-|-|
| Test duration | >32 hours |
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 22 |
| Test summary | **Pass** |

Results: No marks whatsoever. This is a very strong indication that it is indeed the replacement felt pad that is causing the marks in tests 1 & 2 despite them being most prominent on the head side of the disk.
