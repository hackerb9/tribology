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
86  IF X <0  OR X >34  THEN 80
88 T = X
89  PRINT 
90  PRINT "Put test disk in s";S;"d";D;
95  INPUT " (Hit Return) ";X$
100  REM  MONITOR'S GO COMMAND VARS
101  REM  A,X,Y,P  = $45, $46, $47, $48
110 AP = 69:XP = 70:YP = 71:PP = 72
149  REM  PTR TO ADDR OF ROUTINE FOR "GO"
150 AL = 58:AH = 59
169  REM  ADDRESS OF MONITOR'S "GO" COMMAND
170 GO = 65209
200  REM  CALL RWTS
219  REM  IO CONTROL BLOCK $BE98 FOR SLOT 6, DRIVE 1
220 YA = 46984 +S *16
222  IF  PEEK(YA +1) < >S *16  THEN  PRINT "ERROR: Invalid IO control block ("YA")": END 
230 AD = 985
239  REM  SEEK COMMAND CODE
240  POKE YA +12,0
245  POKE YA +2,D
250  POKE YA +4,T
255  PRINT 
259  PRINT "Seeking to track "T" on s"S"d"D
260  GOSUB 500
269  REM  RETURN CODE
270 RV =  PEEK(YA +13)
280  IF RV < >0  THEN  PRINT "ERROR "RV": Could not seek": END 
300  REM  START MOTOR AND SHOW TIME
309  REM   PEEK TO TURN MOTOR ON/OFF
310 MN = 49385:MF = MN -1
319  PRINT "Keeping drive motor on"
320 X =  PEEK(MN)
322  ONERR  GOTO 400
325  GOSUB 1030: REM  reset the keyboard input
330  PRINT "Hit any key to stop the test."
340  REM  CLOCK LOOP
345 LC = LC +1: REM  Loop counter
349  REM   Clock tick for this loop found empirically
350 TI = TI +.15
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
690  RETURN 
800  REM  SHOW ELAPSED TIME GIVEN TI SECONDS
801 TS = 0:TM = 0:TH = 0:
820 TS =  INT(TI +0.5)
830 TM =  INT(TS/60):TS = TS -TM *60
840 TH =  INT(TM/60):TM = TM -TH *60
850  PRINT TH" hour";
853  IF TH < >1  THEN  PRINT "s";
855  IF TH = 1  THEN  PRINT "";
856  PRINT ", ";
860  PRINT TM" minute";
863  IF TM < >1  THEN  PRINT "s";
865  IF TM = 1  THEN  PRINT "";
866  PRINT ", ";
870  PRINT TS" second";
872  IF TS < >1  THEN  PRINT "s";
873  IF TS = 1  THEN  PRINT "";
875  CALL ( -868): REM  Clear to end of line
880  POKE 36,0: REM  Cursor to left margin
890  RETURN 
1000  REM  GET A KEY, NONSTOP
1001  REM  Sets KB to a value >0 if a key is ready and resets the flag
1010 KB =  PEEK( -16384) -128
1020  IF KB <0  THEN  RETURN 
1030  REM  Reset the keyboard flag
1040  POKE  -16368,0
1050  RETURN 
