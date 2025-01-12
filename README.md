# The Trouble With (amateur) Tribology

This repository is for investigating how the parts in the Drive II for
the Apple II computer wear down. (The study of wear is called
"tribology"). In particular, this was motivated by attempting to find
a suitable felt replacement for the head pressure pad that would not
mar the surface.

In order to test a component, use the TRIBOLOGY TRIAL program which
prompts for a track to move the head to and then cycles around on it
forever, perhaps scraping off the magnetic material and etching a ring
into the diskette. 

The program attempts to calculate elapsed wall time but it is not very
accurate, so it's better to use an external clock when possible.[^1]

[^1]: For reasons not clear to me, the speed of my timing loop depends upon whether
it is run automatically as the Apple II "HELLO" program or from the prompt.

An ideal test will run for 7 days straight. 

## Test results

Results will go here.

### Felt Pad #1: Punched from self stick felt pad

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

This is the same felt pad as in Trial 1-B, but after being removed, examined under a microscope, and had the top layer and excess filaments trimmed off. The disk was the same from Trial 1-B since no marks had been left on the felt side. The drive head was also examined and cleaned. 

| | |
|-|-|
| Test duration | 12 hours |
| Testing method | [TRIBOLOGY.bas](TRIBOLOGY.bas) |
| Track # (of 40) | 17 |
| Test summary | **Pass** |

No marks on felt side. No apparent new marks on head side.
