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

### Test 001: Punched from self stick felt pad

| | |
|-----|-----|
|Origin| unknown (gift from deramp5113) |
| Material | Synthetic (melts instead of burning) |
| Filament length | Longer than original | 
| Density | Loosely packed compared to original, but that may be because the original has been used for decades. |
| Notes| This pad had fragments of dried glue which was removed under a microscope before testing. | 
| Test duration | >24 hours |
| Testing method | Apple II attempting to boot a blank disk |
| Track # (of 40) | 0 (outermost) |
| Test summary | **Fail** |

Results: Track 0 has a black ring. Data does not appear to be affected. 
