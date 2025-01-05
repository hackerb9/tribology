0  HOME : PRINT "TRIALS AND TRIBOLOGY"
1  PRINT : PRINT "Run floppy drive on a specific track"
2  PRINT "to see if it etches rings in the disk."
3  PRINT "(Copyleft) 2024 hackerb9": PRINT 
4  REM  MODULO 256 FOR HI/LO BYTES
5  DEF  FN MD(Z) = Z -256 * INT(Z/256)
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
80  PRINT "Track to seek to (Hit Return for "T") ";
82  INPUT X$:X =  VAL(X$)
84  IF X$ = ""  THEN X = T
85  REM  Huh? Why does my Disk II go have 60 tracks instead of 35?
86  IF X <0  OR X >255  THEN 80
88 T = X
89  PRINT 
90  PRINT "Put test disk in s";S;"d";D;
95  INPUT " (Hit Return) ";X$
100  REM  MONITOR'S GO COMMAND VARS
101  REM  A,X,Y,P  = $45, $46, $47, $48
110 AP = 69:XP = 70:YP = 71:PP = 72
149  REM  ADDRESS OF VECTOR USED BY GO TO CALL A ROUTINE
150 AL = 58:AH = 59
169  REM  ADDRESS OF MONITOR'S "GO" COMMAND
170 GO = 65209
179  REM  DOS Hardware Addresses
180 MF = 49288 +S *16:MN = MF +1: REM  MOTOR OFF/ON
182 E1 = MN +1:E2 = E1 +1: REM  Engage drive 1/2
184 L6 = E2 +1:H6 = L6 +1: REM  Q6L and Q6H
186 L7 = H6 +1:H7 = L7 +1: REM  Q7L and Q7H
200  REM  CALL RWTS
210  GOSUB 900: REM  SEEK to track T
300  REM  START MOTOR AND SHOW TIME
319  PRINT "Keeping drive motor on"
320 XX =  PEEK(MN)
322  ONERR  GOTO 400
325  GOSUB 1030: REM  reset the keyboard input
330  PRINT "Hit any key to stop the test."
340  REM  CLOCK LOOP
345 LC = LC +1: REM  Loop counter
349  REM   Clock tick for this loop found empirically
350 TI = TI +.152226291
360  GOSUB 800: REM  Show time elapsed
370  GOSUB 1000: REM  Check keyboard
380  IF KB <0  THEN 340
400  REM  CLEAN UP AND FINISH
405  GOSUB 800
406  PRINT : PRINT 
410  PRINT "Stopping drive motor"
420 X =  PEEK(MF)
430  PRINT "Total Revolutions: "; INT(TI *5 +.5)
499  END 
500  REM  EXECUTE GO COMMAND
501  REM  INPUT:
502  REM     AD = ADDRESS TO "GO" TO
503  REM     A, X, Y, P = REGISTER VALUES  
504  REM     YA = 16-BIT VALUE FOR Y AND A
505  REM           (Y=LOW, A=HIGH)
510  IF (A = 0  AND Y = 0  AND YA >0)  THEN A =  INT(YA/256):Y =  FN MD(YA)
520  POKE AP,A: POKE XP,X: POKE YP,Y: POKE PP,P
530  IF AD = 0  THEN  PRINT "ERROR: NO ADDRESS FOR 'GO'": END 
540  POKE AH, INT(AD/256)
550  POKE AL, FN MD(AD)
560  REM  GOSUB 600
570  CALL GO
580  REM  GOSUB 600
590  RETURN 
600  REM  PRINT OUT MONITOR'S SAVED REGISTERS
610  PRINT "A: " PEEK(AP),
620  PRINT "X: " PEEK(XP),
630  PRINT "Y: " PEEK(YP),
640  PRINT "P: " PEEK(PP)
650  PRINT "YA = " PEEK(AP) *256 + PEEK(YP)
660  PRINT 
670  PRINT "YYXX: ";: CALL  -1728
680  PRINT "AA: ";: CALL  -550
690  RETURN 
700  REM  DSKF2: INIT ONE TRACK -- does not work yet.
701 MN = 49385:MF = MN -1: REM  MOTOR ON/OFF
702  POKE YA +12,0
703  GOSUB 500
704 XX =  PEEK(MN)
705  PRINT "Type YES to init track "T
706  INPUT X$
707  IF X$ < >"YES"  THEN  GOTO 400: REM  END
708 EN = 12 *16 *16 *16 +8 *16 +10 *16 +S *16 +D -1:XX =  PEEK(EN)
709  REM  DSKF2 is at $BF0D
710 D2 = 13 +0 *16 +15 *16 *16 +11 *16 *16 *16
715 D2 = D2 +S *16
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
750  STOP 
759  REM  Call DSKF2
760  CALL D2
770  REM  When we return, RWTS will be called again to check if it worked.
799  RETURN 
800  REM  SHOW ELAPSED TIME GIVEN TI SECONDS
801 TS = 0:TM = 0:TH = 0:
820 TS =  INT(TI +0.5)
830 TM =  INT(TS/60):TS = TS -TM *60
840 TH =  INT(TM/60):TM = TM -TH *60
850  PRINT TH" hour";
851  IF TH < >1  THEN  PRINT "s";
852  IF TH = 1  THEN  PRINT "";
856  PRINT ", ";
860  PRINT TM" minute";
861  IF TM < >1  THEN  PRINT "s";
862  IF TM = 1  THEN  PRINT "";
866  PRINT ", ";
870  PRINT TS" second";
871  IF TS < >1  THEN  PRINT "s";
872  IF TS = 1  THEN  PRINT "";
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
955  PRINT 
956  PRINT CC$;
957  IF CC < >3  THEN  PRINT " track "T;
958  PRINT " on s"S"d"D
960  GOSUB 500
969  REM  Read return value from IOB
970 RV =  PEEK(YA +13)
980  IF RV = 0  THEN  RETURN 
990  PRINT "ERROR "RV
991  IF RV = 16  THEN  PRINT "Write protected"
992  IF RV = 32  THEN  PRINT "Volume mismatch"
993  IF RV = 64  THEN  PRINT "Drive error"
994  IF RV = 128  THEN  PRINT "Read error"
995  END 
1000  REM  GET A KEY, NONSTOP
1001  REM  Sets KB to a value >0 if a key is ready and resets the flag
1010 KB =  PEEK( -16384) -128
1020  IF KB <0  THEN  RETURN 
1030  REM  Reset the keyboard flag
1040  POKE  -16368,0
1050  RETURN 
2000  REM  Test of reading raw bytes from disk
2005 MN = 49385:MF = MN -1
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
