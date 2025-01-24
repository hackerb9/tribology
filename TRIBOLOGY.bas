0  PRINT  CHR$(17): HOME : PRINT "TRIALS AND TRIBOLOGY"
1  PRINT : PRINT "Run floppy drive on a specific track"
2  PRINT "to see if it etches rings in the disk."
3  PRINT "(Copyleft) 2025 hackerb9": PRINT 
10 S = 6:D = 1:T = 17
20  PRINT "Slot number (hit Return for "S") ";
21  INPUT X$:X =  VAL(X$)
24  IF X$ = ""  THEN X = S
26  IF X <0  OR X >7  THEN 20
28 S = X
50  PRINT "Drive number (hit Return for "D") ";
51  INPUT X$:X =  VAL(X$)
54  IF X$ = ""  THEN X = D
56  IF X <1  OR X >2  THEN 50
58 D = X
70  PRINT "Track to seek to (Hit Return for "T")";
72  INPUT X$:X =  VAL(X$)
74  IF X$ = ""  THEN X = T
76  IF X <0  OR X >255  THEN 80
78 T = X
80  GOSUB 610: REM  Keep Motor On
83  ONERR  GOTO 400: REM    Turn off motor on ^C  
85  POKE 222,255: REM Set ONERR error number to be ignored unless an error actually occurs
88  PRINT 
90  PRINT "Put test disk in s";S;"d";D;" and slowly"
92  PRINT "close the drive door";
94  INPUT " (hit return) ";XX$
95  GOSUB 200: REM  Calibrate track zero
96  GOSUB 900: REM  Seek to track T
98  PRINT 
99  GOTO 300
200  REM  Calibrate to track zero
201  REM  Input: S = Slot, D = Drive
204  REM  note this is needed because the Apple II "remembers" what track it is on and uses relative motions, double-checking that the track number written on the disk matches. Of course, this doesn't work for blank disks.
205  REM  seeking to 35 then 0 is a guess that seems to work. should probably figure out the correct way to do this.
210 TT = T
220 T = 35: GOSUB 900
230 T = 0: GOSUB 900
240 T = TT
250  RETURN 
300  REM  START MOTOR AND SHOW TIME
310  GOSUB 1030: REM Reset the keyboard input
330  PRINT "Keeping drive motor on"
333 XX =  PEEK(MN)
335  PRINT "Hit any key to stop the test."
340  REM  CLOCK LOOP
345 LC = LC +1: REM  Loop counter
348  REM  Force TI to double precision addition to keep constant speed
349  REM   Clock tick for this loop found empirically
350 TI = TI +.168634064
352  IF TI >1  THEN TS = TS +1:TI = TI -1
353  IF TS = 60  THEN TM = TM +1:TS = 0
354  IF TM = 60  THEN TH = TH +1:TM = 0
360  GOSUB 800: REM  Show time elapsed
370  GOSUB 1000: REM  Check keyboard
380  IF KB <0  THEN 340
400  REM  CLEAN UP AND FINISH
403  POKE 36,0: REM  Cursor to left margin
405  GOSUB 800
406  PRINT : PRINT 
410  PRINT "Stopping drive motor"
420  GOSUB 620
430  PRINT "Total Revolutions: ";
440 RV =  INT(TI +TS +TM *60 +TH *60 *60)
445 RV = RV *5: REM Five rotations per second
450  PRINT RV
460 ER =  PEEK(222): REM  ON ERR GOTO error number
470  IF ER = 255  THEN  END : REM  ^C is okay to quit
480  PRINT "Error number ";ER
485  POKE 216,0: REM  Reset ON ERR
490  RESUME 
499  END 
500  REM  EXECUTE GO COMMAND
501  REM  INPUT:
502  REM     AD = ADDRESS TO "GO" TO
503  REM     A, X, Y, P = REGISTER VALUES  
504  REM     YA = 16-BIT VALUE FOR Y AND A
505  REM           (Y=LOW, A=HIGH)
506  REM  Monitor's GO command vars: A,X,Y,P = $45, $46, $47, $48
507 AP = 69:XP = 70:YP = 71:PP = 72
508 AL = 58:AH = 59: REM  Address of vectored used by GO to call a routine
509 GO = 65209: REM  Address of monitor's "GO" command
510  IF (A = 0  AND Y = 0  AND YA >0)  THEN A =  INT(YA/256):Y = (YA -256 * INT(YA/256))
520  POKE AP,A: POKE XP,X: POKE YP,Y: POKE PP,P
530  IF AD = 0  THEN  PRINT "ERROR: NO ADDRESS FOR 'GO'": END 
540  POKE AH, INT(AD/256)
550  POKE AL,(AD -256 * INT(AD/256))
570  CALL GO
590  RETURN 
600  REM  DOS control addresses
601 E1 = 49290 +S *16:XX =  PEEK(E1): RETURN : REM  Engage drive 1
602 E2 = 49291 +S *16:XX =  PEEK(E2): RETURN : REM  Engage drive 2
610  REM  Motor On: INPUT S = slot #, D = drive #
611  IF S = 0  THEN  PRINT "Set S to controller slot before calling 610": STOP 
612 MN = 49289 +S *16: REM  Motor On
613  IF D = 1  THEN  GOSUB 601
614  IF D = 2  THEN  GOSUB 602
615 XX =  PEEK(MN)
616  RETURN 
620  REM  Motor Off: Input S = slot #
621  IF S = 0  THEN  PRINT "Set S to controller slot before calling 620": STOP 
622 MF = 49288 +S *16: REM  Motor Off
623  REM  Note: Turns off motor to both drives
624 XX =  PEEK(MF)
625  RETURN 
640  REM   Q6/Q7 drive control  
642 L6 = E2 +1:H6 = L6 +1: REM    Q6L and Q6H 
644 L7 = H6 +1:H7 = L7 +1: REM    Q7L and Q7H 
650  REM  Write Protect Check
651  REM  INPUT: S is slot, D is drive
652  REM  OUTPUT: WP is 0 if disk is writable
660  REM  see 2000
690  RETURN 
700  REM  DSKF2: INIT ONE TRACK
701 MN = 49385:MF = MN -1: REM  MOTOR ON/OFF
703  GOSUB 900
704 XX =  PEEK(MN)
705  PRINT "Type YES to init track "T
706  INPUT X$
707  IF X$ < >"YES"  THEN  GOTO 400: REM  END
719  REM  WRADR16 uses $41,$44 for VOL and TRACK
720  POKE 4 *16 +1,0
721  POKE 4 *16 +4,T
729  REM  DSKF2 uses $45 for number of syncs between sectors to start
730  POKE 4 *16 +5,40
734  REM  Z-PAGE CONSTANT FOR TIMING
735  POKE 3 *16 +14,10 *16 +10
739  REM  Clear primary and secondary sector buffers at $BB00 and $BC00
740 BU = 11 *16 *16 *16 +11 *16 *16
742  FOR XX = BU TO BU +256 +85
743  POKE XX,0
744  NEXT XX
749  REM   DSKF2 is at $BF0D 
750 D2 = 13 +0 *16 +15 *16 *16 +11 *16 *16 *16
755  STOP 
759  REM  Call DSKF2
760  CALL D2
770  REM  Should call Read from RWTS to see if it worked.
799  RETURN 
800  REM  SHOW ELAPSED TIME GIVEN TI SECONDS
850  PRINT TH" hour";
851  IF TH < >1  THEN  PRINT "s";
852  IF TH = 1  THEN  PRINT " ";
856  PRINT ", ";
860  PRINT TM" minute";
861  IF TM < >1  THEN  PRINT "s";
862  IF TM = 1  THEN  PRINT " ";
866  PRINT ", ";
870  PRINT TS" second";
871  IF TS < >1  THEN  PRINT "s";
872  IF TS = 1  THEN  PRINT " ";
875  CALL ( -868): REM  Clear to end of line
880  POKE 36,0: REM  Cursor to left margin
890  RETURN 
899  REM  RWTS: Read/Write Track/Sector
900 CC$ = "Seeking":CC = 0: GOTO 910
901 CC$ = "Reading":CC = 1: GOTO 910
902 CC$ = "Writing":CC = 2: GOTO 910
903 CC$ = "Formatting":CC = 3: GOTO 910
905  REM  cc: 1=seek, 2=r, 3=w, 4=fmt
906  REM  INPUT: S=slot, D=drive, T=track
910  REM  CALL RWTS
915 AD = 985: REM  Address of RWTS to "GO" to
919  REM  IO CONTROL BLOCK FOR SLOT 6, DRIVE 1 IS $BE98
920 YA = 46984 +S *16
930  IF  PEEK(YA +1) < >S *16  THEN  PRINT "ERROR: Invalid IO control block ("YA")": END 
939  REM  Fill IOB values
940  POKE YA +12,CC: REM  Command code
942  POKE YA +2,D: REM  Drive number
943  POKE YA +3,0: REM  Any volume
944  POKE YA +4,T: REM  Track number
948  POKE YA +8,00: POKE YA +9,4: REM  Use screen for buffer
949  IF  POS(0) >0  THEN  PRINT 
950  PRINT CC$;
952  IF CC < >3  THEN  PRINT " track "T;
957  IF CC = 1  OR CC = 2  THEN  PRINT " sector "SC;
958  PRINT " on s"S"d"D
959  IF CC = 2  OR CC = 3  THEN  INPUT "ARE YOU SURE? ";XX$: IF XX$ < >"YES"  THEN  END 
960  GOSUB 500
969  REM  Read return value from IOB
970 RV =  PEEK(YA +13)
980  IF RV = 0  THEN  RETURN 
990  PRINT "ERROR "RV
991  IF RV = 16  THEN  PRINT "Write protected"
992  IF RV = 32  THEN  PRINT "Volume mismatch"
993  IF RV = 64  THEN  PRINT "Drive error"
994  IF RV = 128  THEN  PRINT "Read error"
995  GOSUB 620: REM  Motor Off
999  END 
1000  REM  GET A KEY, NONSTOP
1001  REM  Sets KB to a value >0 if a key is ready and resets the flag
1010 KB =  PEEK( -16384) -128
1020  IF KB <0  THEN  RETURN 
1030  REM  Reset the keyboard flag
1040  POKE  -16368,0
1050  RETURN 
1111  REM It's always 11:11 somewhere.
1115  IF S = 0  THEN  PRINT "Slot not set"
1118  REM  Reset timer to zero for icalculating clock tick in line 350
1119 TH = 0:TM = 0:TS = 0:TI = 0
1120 LC = 0: REM  loop counter
1130  GOTO 333
2000 MN = 49385:MF = MN -1
2010 E1 = MN +1:E2 = E1 +1
2020 L6 = E2 +1:H6 = L6 +1
2030 L7 = H6 +1:H7 = L7 +1
2032  ONERR  GOTO 400
2035  PRINT "motor on: "; PEEK(MN)
2040  REM  sense write protect is q7l q6h
2045  PRINT "wp: ";
2050 XX =  PEEK(H6): PRINT  PEEK(L7)
2060  REM  read is q7l q6l
2063 XX =  PEEK(L7)
2065  PRINT "read: ";
2070 XX =  PEEK(L6)
2080  POKE 1024 +I,XX
2081 I = I +1
2085  IF I >255  THEN I = 0
2090  GOTO 2070

