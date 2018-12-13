/*
--- Day 12: Subterranean Sustainability ---

--- Part Two ---

You realize that 20 generations aren't enough. After all, these plants will need to last another 1500 years to even reach your timeline, not to mention your future.

After fifty billion (50000000000) generations, what is the sum of the numbers of all pots which contain a plant?

*/
&GLOBAL-DEFINE xiIterations 1000

DEFINE VARIABLE c         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDummy    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNewState AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cState    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFirstPot AS INT64       NO-UNDO.
DEFINE VARIABLE iPot      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSum      AS INT64       NO-UNDO.


DEFINE TEMP-TABLE ttNote NO-UNDO
 FIELD cFrom AS CHARACTER  
 FIELD cTo   AS CHARACTER  
 INDEX ix IS PRIMARY UNIQUE cFrom.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day12.txt.

IMPORT UNFORMATTED cLine.
cState = REPLACE(cLine, "initial state: ", "").
iFirstPot = 0.

IMPORT UNFORMATTED cLine.

REPEAT:
    CREATE ttNote.
    IMPORT ttNote.cFrom cDummy ttNote.cTo.
END.
DELETE ttNote.

INPUT CLOSE.

/* OUTPUT TO c:/temp/states.txt. */
/* PUT UNFORMATTED 0 ": " iFirstPot " " cState SKIP. */
DO i = 1 TO {&xiIterations}:
    /* ensure cState begins and ends in "...." */
    IF cState BEGINS "#" THEN ASSIGN cState = "...." + cState iFirstPot = iFirstPot - 4.
    ELSE IF cState BEGINS ".#" THEN ASSIGN cState = "..." + cState iFirstPot = iFirstPot - 3.
    ELSE IF cState BEGINS "..#" THEN ASSIGN cState = ".." + cState iFirstPot = iFirstPot - 2.
    ELSE IF cState BEGINS "...#" THEN ASSIGN cState = "." + cState iFirstPot = iFirstPot - 1.
    c = SUBSTRING(cState,LENGTH(cState) - 3,4).
    IF c <> "...." THEN cState = cState + ".".
    c = SUBSTRING(cState,LENGTH(cState) - 3,4).
    IF c <> "...." THEN cState = cState + ".".
    c = SUBSTRING(cState,LENGTH(cState) - 3,4).
    IF c <> "...." THEN cState = cState + ".".
    c = SUBSTRING(cState,LENGTH(cState) - 3,4).
    IF c <> "...." THEN cState = cState + ".".

    cNewState = "..".
    DO iPot = 3 TO LENGTH(cState) - 2:
        FIND ttNote WHERE ttNote.cFrom = SUBSTRING(cState, iPot - 2, 5) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN 
            cNewState = cNewState + ".".
        ELSE
            cNewState = cNewState + ttNote.cTo.
    END.

    /* remove unnecessary "." at the start */
    DO WHILE TRUE:
        c = SUBSTRING(cNewState,1,4).
        IF c <> "...." THEN LEAVE.
        cNewState = SUBSTRING(cNewState, 2).
        iFirstPot = iFirstPot + 1.
    END.

    IF TRIM(cState, ".") = TRIM(cNewState, ".") THEN LEAVE. /* same pattern indefinitely */
    cState = cNewState.
    /* PUT UNFORMATTED i ": " iFirstPot " " cState SKIP. */
END.
/* OUTPUT CLOSE. */

/* TODO: maybe the shift is not always 1, depending on the input */

iFirstPot = 50000000000 - (i - iFirstPot + 1).
iSum = 0.
DO i = 0 TO LENGTH(cState) - 1:
    IF SUBSTRING(cState,i + 1,1) = "#" THEN
        iSum = iSum + i + iFirstPot.
END.

MESSAGE ETIME SKIP
    iFirstPot LENGTH(cState) SKIP
    iSum
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 50.000.000.000 generations */
/* starting with iteration 100, all the lines are equal, with a shift of 1 to the right at each iteration */
/* 100: 47  ...#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#. */
/* 500: 447 ...#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#. */
/* --> for iteration 50.000.000.000 the first pot will be 50b-53 */

/* 2500000001175 */
