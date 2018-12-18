/*
--- Day 17: Reservoir Research ---

You arrive in the year 18. If it weren't for the coat you got in 1018, you would be very cold: the North Pole base hasn't even been constructed.

Rather, it hasn't been constructed yet. The Elves are making a little progress, but there's not a lot of liquid water in this climate, so they're getting very dehydrated. Maybe there's more underground?

You scan a two-dimensional vertical slice of the ground nearby and discover that it is mostly sand with veins of clay. The scan only provides data with a granularity of square meters, but it should be good enough to determine how much water is trapped there. In the scan, x represents the distance to the right, and y represents the distance down. There is also a spring of water near the surface at x=500, y=0. The scan identifies which square meters are clay (your puzzle input).

For example, suppose your scan shows the following veins of clay:

x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504

Rendering clay as #, sand as ., and the water spring as +, and with x increasing to the right and y increasing downward, this becomes:

   44444455555555
   99999900000000
   45678901234567
 0 ......+.......
 1 ............#.
 2 .#..#.......#.
 3 .#..#..#......
 4 .#..#..#......
 5 .#.....#......
 6 .#.....#......
 7 .#######......
 8 ..............
 9 ..............
10 ....#.....#...
11 ....#.....#...
12 ....#.....#...
13 ....#######...

The spring of water will produce water forever. Water can move through sand, but is blocked by clay. Water always moves down when possible, and spreads to the left and right otherwise, filling space that has clay on both sides and falling out otherwise.

For example, if five squares of water are created, they will flow downward until they reach the clay and settle there. Water that has come to rest is shown here as ~, while sand through which water has passed (but which is now dry again) is shown as |:

......+.......
......|.....#.
.#..#.|.....#.
.#..#.|#......
.#..#.|#......
.#....|#......
.#~~~~~#......
.#######......
..............
..............
....#.....#...
....#.....#...
....#.....#...
....#######...

Two squares of water can't occupy the same location. If another five squares of water are created, they will settle on the first five, filling the clay reservoir a little more:

......+.......
......|.....#.
.#..#.|.....#.
.#..#.|#......
.#..#.|#......
.#~~~~~#......
.#~~~~~#......
.#######......
..............
..............
....#.....#...
....#.....#...
....#.....#...
....#######...

Water pressure does not apply in this scenario. If another four squares of water are created, they will stay on the right side of the barrier, and no water will reach the left side:

......+.......
......|.....#.
.#..#.|.....#.
.#..#~~#......
.#..#~~#......
.#~~~~~#......
.#~~~~~#......
.#######......
..............
..............
....#.....#...
....#.....#...
....#.....#...
....#######...

At this point, the top reservoir overflows. While water can reach the tiles above the surface of the water, it cannot settle there, and so the next five squares of water settle like this:

......+.......
......|.....#.
.#..#||||...#.
.#..#~~#|.....
.#..#~~#|.....
.#~~~~~#|.....
.#~~~~~#|.....
.#######|.....
........|.....
........|.....
....#...|.#...
....#...|.#...
....#~~~~~#...
....#######...

Note especially the leftmost |: the new squares of water can reach this tile, but cannot stop there. Instead, eventually, they all fall to the right and settle in the reservoir below.

After 10 more squares of water, the bottom reservoir is also full:

......+.......
......|.....#.
.#..#||||...#.
.#..#~~#|.....
.#..#~~#|.....
.#~~~~~#|.....
.#~~~~~#|.....
.#######|.....
........|.....
........|.....
....#~~~~~#...
....#~~~~~#...
....#~~~~~#...
....#######...

Finally, while there is nowhere left for the water to settle, it can reach a few more tiles before overflowing beyond the bottom of the scanned data:

......+.......    (line not counted: above minimum y value)
......|.....#.
.#..#||||...#.
.#..#~~#|.....
.#..#~~#|.....
.#~~~~~#|.....
.#~~~~~#|.....
.#######|.....
........|.....
...|||||||||..
...|#~~~~~#|..
...|#~~~~~#|..
...|#~~~~~#|..
...|#######|..
...|.......|..    (line not counted: below maximum y value)
...|.......|..    (line not counted: below maximum y value)
...|.......|..    (line not counted: below maximum y value)

How many tiles can be reached by the water? To prevent counting forever, ignore tiles with a y coordinate smaller than the smallest y coordinate in your scan data or larger than the largest one. Any x coordinate is valid. In this example, the lowest y coordinate given is 1, and the highest is 13, causing the water spring (in row 0) and the water falling off the bottom of the render (in rows 14 through infinity) to be ignored.

So, in the example above, counting both water at rest (~) and other sand tiles the water can hypothetically reach (|), the total number of tiles the water can reach is 57.

How many tiles can the water reach within the range of y values in your scan?

*/
DEFINE VARIABLE c       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine   AS CHARACTER   EXTENT 2 NO-UNDO.
DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i1      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i2      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount2 AS INTEGER     NO-UNDO.
DEFINE VARIABLE iX      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iXMax   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iXMin   AS INTEGER     INITIAL 999999 NO-UNDO.
DEFINE VARIABLE iY      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iYMax   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iYMin   AS INTEGER     INITIAL 999999 NO-UNDO.
DEFINE VARIABLE j       AS INTEGER     NO-UNDO.
DEFINE VARIABLE lX      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lY      AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttScan NO-UNDO 
 FIELD iXMin AS INTEGER
 FIELD iXMax AS INTEGER
 FIELD iYMin AS INTEGER
 FIELD iYMax AS INTEGER
 INDEX ix iXMax iXMin iYMax iYMin.

DEFINE TEMP-TABLE ttSoil NO-UNDO
 FIELD iY AS INTEGER
 FIELD cSoil AS CHARACTER
 INDEX ix IS PRIMARY UNIQUE iY.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day17.txt.
REPEAT:
    IMPORT cLine.
    CREATE ttScan.
    DO i = 1 TO 2:
        ASSIGN
            lX = NO
            lY = NO.
        IF cLine[i] BEGINS "x=" THEN lX = YES.
        ELSE IF cLine[i] BEGINS "y=" THEN lY = YES.
        cLine[i] = RIGHT-TRIM(SUBSTRING(cLine[i], 3), ",").
        IF INDEX(cLine[i], ".") > 0 THEN DO: /* n..m */
            i1 = INTEGER(ENTRY(1, cLine[i], ".")).
            i2 = INTEGER(ENTRY(3, cLine[i], ".")).
            IF lX THEN ASSIGN
                ttScan.iXMin = i1
                ttScan.iXMax = i2
                iXMin        = MINIMUM(iXMin, i1)
                iXMax        = MAXIMUM(iXMax, i2).
            ELSE IF lY THEN ASSIGN
                ttScan.iYMin = i1
                ttScan.iYMax = i2
                iYMin        = MINIMUM(iYMin, i1)
                iYMax        = MAXIMUM(iYMax, i2).
        END.
        ELSE DO: /* n */
            i1 = INTEGER(cLine[i]).
            IF lX THEN ASSIGN
                ttScan.iXMin = i1
                ttScan.iXMax = i1
                iXMin        = MINIMUM(iXMin, i1)
                iXMax        = MAXIMUM(iXMax, i1).
            ELSE IF lY THEN ASSIGN
                ttScan.iYMin = i1
                ttScan.iYMax = i1
                iYMin        = MINIMUM(iYMin, i1)
                iYMax        = MAXIMUM(iYMax, i1).
        END.
    END.
END.
INPUT CLOSE.
ASSIGN
    iXMin = iXMin - 1
    iXMax = iXMax + 1.

/* create soil */
DO j = iYMin TO iYMax:
    CREATE ttSoil.
    ASSIGN ttSoil.iY = j
           ttSoil.cSoil = FILL(".", iXMax - iXMin + 1).
END.
FOR EACH ttScan:
    DO j = ttScan.iYMin TO ttScan.iYMax:
        FIND ttSoil WHERE ttSoil.iY = j.
        DO i = ttScan.iXMin TO ttScan.iXMax:
            SUBSTRING(ttSoil.cSoil, i - iXMin + 1) = "#".
        END.
    END.
END.

/* pour water in column 500 */
ASSIGN
    iX = 500
    iY = iYMin.
RUN pourWater (iX, iY).

OUTPUT TO c:/temp/soil.txt.
FOR EACH ttSoil:
    PUT UNFORMATTED STRING(ttSoil.iY, "9999") " " ttSoil.cSoil SKIP.
END.
OUTPUT CLOSE.

/* FOR EACH ttOp: */
    /* DISP ttOp.iOpCode ttOp.cOperation FORMAT "X(30)". */
/* END. */

FOR EACH ttSoil:
    DO i = LENGTH(ttSoil.cSoil) TO 1 BY -1:
        c = SUBSTRING(ttSoil.cSoil,i,1).
        IF c = "~~" THEN ASSIGN
            iCount  = iCount + 1
            iCount2 = iCount2 + 1.
        ELSE IF c = "|" THEN ASSIGN
            iCount = iCount + 1.
    END.
END.

MESSAGE ETIME SKIP
    iXMin iXMax SKIP
    iYMin iYMax SKIP
    iCount SKIP
    iCount2
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 1056 */
/* 464 637 */
/* 3 1816 */
/* 31953 */
/* 26410 */

PROCEDURE pourWater:
    DEFINE INPUT  PARAMETER iX AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER iYStart AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cb       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iXFrom   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iXTo     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lPourred AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lXFrom   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lXTo     AS LOGICAL     NO-UNDO.

    DEFINE BUFFER ttSoil  FOR ttSoil.
    DEFINE BUFFER bttSoil FOR ttSoil.

    iY = iYStart.
    FIND ttSoil WHERE ttSoil.iY = iY NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.
    blkDown:
    DO WHILE SUBSTRING(ttSoil.cSoil, iX - iXMin + 1, 1) = ".":
        SUBSTRING(ttSoil.cSoil, iX - iXMin + 1, 1) = "|".
        iY = iY + 1.
        FIND ttSoil WHERE ttSoil.iY = iY NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RETURN. /* We are past iYMax */
    END.
    iY = iY - 1.
    blkFill:
    DO WHILE TRUE:
        FIND ttSoil WHERE ttSoil.iY = iY.
        FIND bttSoil WHERE bttSoil.iY = iY + 1.
        c = SUBSTRING(bttSoil.cSoil, iX - iXMin + 1, 1).
        IF c = "#" OR c = "~~" OR c = "|" THEN ASSIGN
            SUBSTRING(ttSoil.cSoil, iX - iXMin + 1, 1) = "~~".
        ASSIGN
            lPourred = NO
            cb       = SUBSTRING(bttSoil.cSoil, iX - iXMin + 1, 1)
            i        = iX - 1
            c        = SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1)
            .
        IF cb <> "|" THEN
        blkLeft:
        DO WHILE c = "." OR c = "~~" OR c = "|":
            cb = SUBSTRING(bttSoil.cSoil, i - iXMin + 1, 1).
            IF cb = "#" OR cb = "~~" THEN ASSIGN
                lPourred = NO
                SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1) = "~~"
                i = i - 1.
            ELSE IF cb = "." THEN DO:
                IF lPourred THEN
                    LEAVE blkLeft.
                ELSE DO:
                    RUN pourWater (i, iY).
                    lPourred = YES.
                END.
                /* LEAVE blkLeft. */
            END.
            ELSE IF cb = "|" THEN
                LEAVE blkLeft.
ELSE MESSAGE 1 VIEW-AS ALERT-BOX INFO BUTTONS OK.
            c = SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1).
        END.
        ASSIGN
            lXFrom   = c = "#"
            iXFrom   = i
            lPourred = NO
            cb       = SUBSTRING(bttSoil.cSoil, iX - iXMin + 1, 1)
            i        = iX + 1
            c        = SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1)
            .
        IF cb <> "|" THEN
        blkRight:
        DO WHILE c = "." OR c = "~~" OR c = "|":
            cb = SUBSTRING(bttSoil.cSoil, i - iXMin + 1, 1).
            IF cb = "#" OR cb = "~~" THEN ASSIGN
                lPourred = NO
                SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1) = "~~"
                i = i + 1.
            ELSE IF cb = "." THEN DO:
                IF lPourred THEN
                    LEAVE blkRight.
                ELSE DO:
                    RUN pourWater (i, iY).
                    lPourred = YES.
                END.
                /* LEAVE blkRight. */
            END.
            ELSE IF cb = "|" THEN
                LEAVE blkRight.
ELSE MESSAGE 2 VIEW-AS ALERT-BOX INFO BUTTONS OK.
            c = SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1).
        END.
        ASSIGN
            lXTo = c = "#"
            iXTo = i.
        IF NOT lXFrom OR NOT lXTo THEN DO i = iXFrom + 1 TO iXTo - 1:
            SUBSTRING(ttSoil.cSoil, i - iXMin + 1, 1) = "|".
        END.
        iY = iY - 1.
        IF iY <= iYStart THEN RETURN.
    END.
END PROCEDURE.

