/*
--- Day 3: No Matter How You Slice It ---

--- Part Two ---

Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make Santa's suit after all!

For example, in the claims above, only claim 3 is intact after all claims are made.

What is the ID of the only claim that doesn't overlap?

*/
DEFINE VARIABLE c       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCol    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxCol AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxRow AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRow    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttClaim NO-UNDO
 FIELD iClaim   AS INTEGER  
 FIELD iCol     AS INTEGER  
 FIELD iRow     AS INTEGER  
 FIELD iWidth   AS INTEGER  
 FIELD iHeight  AS INTEGER  
 FIELD lOverlap AS LOGICAL  
 INDEX ix IS PRIMARY UNIQUE iClaim
 INDEX io lOverlap
 .

DEFINE BUFFER bttClaim FOR ttClaim.

DEFINE TEMP-TABLE ttFabric NO-UNDO
 FIELD iRow      AS INTEGER    
 FIELD iRowClaim AS INTEGER     EXTENT 1000
 /* FIELD cOverlap  AS CHARACTER   EXTENT 1000 */
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

FOR EACH ttClaim BY ttClaim.iClaim:
    DO iRow = ttClaim.iRow TO ttClaim.iRow + ttClaim.iHeight - 1:
        FIND ttFabric WHERE ttFabric.iRow = iRow.
        DO iCol = ttClaim.iCol TO ttClaim.iCol + ttClaim.iWidth - 1:
            IF ttFabric.iRowClaim[iCol + 1] > 0 THEN DO:
                /* ttFabric.cOverlap[iCol + 1] = "X". */
                FIND bttClaim WHERE bttClaim.iClaim = ttFabric.iRowClaim[iCol + 1].
                ASSIGN
                    ttClaim.lOverlap  = YES
                    bttClaim.lOverlap = YES.
            END.
            ttFabric.iRowClaim[iCol + 1] = ttClaim.iClaim.
        END.
    END.
END.

FIND ttClaim WHERE ttClaim.lOverlap = NO.

MESSAGE ETIME SKIP
    ttClaim.iClaim
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 3066 */
/* 1067 */

