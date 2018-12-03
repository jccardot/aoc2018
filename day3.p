/*
--- Day 3: No Matter How You Slice It ---

The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

    The number of inches between the left edge of the fabric and the left edge of the rectangle.
    The number of inches between the top edge of the fabric and the top edge of the rectangle.
    The width of the rectangle in inches.
    The height of the rectangle in inches.

A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

...........
...........
...#####...
...#####...
...#####...
...#####...
...........
...........
...........

The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2

Visually, these claim the following areas:

........
...2222.
...2222.
.11XX22.
.11XX22.
.111133.
.111133.
........

The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?

*/
DEFINE VARIABLE c       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCol    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxCol AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxRow AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRow    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttClaim NO-UNDO
 FIELD iClaim  AS INTEGER  
 FIELD iCol    AS INTEGER  
 FIELD iRow    AS INTEGER  
 FIELD iWidth  AS INTEGER  
 FIELD iHeight AS INTEGER  
 INDEX ix IS PRIMARY UNIQUE iClaim
    .

DEFINE TEMP-TABLE ttFabric NO-UNDO
 FIELD iRow AS INTEGER
 FIELD cRow AS CHARACTER EXTENT 1000
 INDEX ix IS PRIMARY UNIQUE iRow.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day3.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    CREATE ttClaim.
    ttClaim.iClaim = INTEGER(LEFT-TRIM(ENTRY(1, cLine," "), "#")).
    c = ENTRY(3, cLine, " ").
    ttClaim.iCol = INTEGER(ENTRY(1, c)).
    ttClaim.iRow = INTEGER(RIGHT-TRIM(ENTRY(2, c), ":")).
    c = ENTRY(4, cLine, " ").
    ttClaim.iWidth = INTEGER(ENTRY(1, c, "x")).
    ttClaim.iHeight = INTEGER(ENTRY(2, c, "x")).
    ASSIGN
        iMaxCol = MAX(iMaxCol, ttClaim.iCol + ttClaim.iWidth - 1)
        iMaxRow = MAX(iMaxRow, ttClaim.iRow + ttClaim.iHeight - 1).
END.
INPUT CLOSE.

DO iRow = iMaxRow TO 0 BY -1:
    CREATE ttFabric.
    ASSIGN ttFabric.iRow = iRow.
END.

FOR EACH ttClaim:
    DO iRow = ttClaim.iRow TO ttClaim.iRow + ttClaim.iHeight - 1:
        FIND ttFabric WHERE ttFabric.iRow = iRow.
        DO iCol = ttClaim.iCol TO ttClaim.iCol + ttClaim.iWidth - 1:
            ttFabric.cRow[iCol + 1] = 
                IF ttFabric.cRow[iCol + 1] > "" THEN "X" ELSE STRING(ttClaim.iClaim).
        END.
    END.
END.

FOR EACH ttFabric:
    DO iCol = 1 TO 1000:
        IF ttFabric.cRow[iCol] = "X" THEN iCount = iCount + 1.
    END.
END.

MESSAGE ETIME SKIP
    iCount
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 2347 */
/* 101469 */

