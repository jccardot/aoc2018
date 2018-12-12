/*
--- Day 11: Chronal Charge ---

--- Part Two ---

You discover a dial on the side of the device; it seems to let you select a square of any size, not just 3x3. Sizes from 1x1 to 300x300 are supported.

Realizing this, you now must find the square of any size with the largest total power. Identify this square by including its size as a third parameter after the top-left coordinate: a 9x9 square with a top-left corner of 3,5 is identified as 3,5,9.

For example:

    For grid serial number 18, the largest total square (with a total power of 113) is 16x16 and has a top-left corner of 90,269, so its identifier is 90,269,16.
    For grid serial number 42, the largest total square (with a total power of 119) is 12x12 and has a top-left corner of 232,251, so its identifier is 232,251,12.

What is the X,Y,size identifier of the square with the largest total power?

*/
&GLOBAL-DEFINE xiSerialNb 5235

DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
DEFINE VARIABLE ii       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPower   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSizeMax AS INTEGER   NO-UNDO.
DEFINE VARIABLE j        AS INTEGER   NO-UNDO.
DEFINE VARIABLE jj       AS INTEGER   NO-UNDO.
DEFINE VARIABLE k        AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE ttGrid NO-UNDO
 FIELD iX        AS INTEGER  
 FIELD iY        AS INTEGER  
 FIELD iPower    AS INTEGER  
 INDEX ix IS PRIMARY UNIQUE iX iY.

DEFINE BUFFER bttGrid FOR ttGrid.

DEFINE TEMP-TABLE ttSquare NO-UNDO
 FIELD iX     AS INTEGER  
 FIELD iY     AS INTEGER  
 FIELD iSize  AS INTEGER  
 FIELD iPower AS INTEGER  
 INDEX ix IS PRIMARY UNIQUE iX iY iSize
 INDEX ip iPower DESCENDING.

ETIME(YES).

/* create grid and compute cells power */
DO j = 1 TO 300:
    DO i = 1 TO 300:
        CREATE ttGrid.
        ASSIGN ttGrid.iX     = i
               ttGrid.iY     = j
               ttGrid.iPower = TRUNCATE( ( ( (i + 10) * j + {&xiSerialNb} ) * (i + 10)) / 100, 0) MODULO 10 - 5.

    END.
END.

/* compute square zones power */
OUTPUT TO c:/temp/day11.log.
DO j = 1 TO 298:
    DO i = 1 TO 298:
PUT UNFORMATTED ETIME "-" i "," j SKIP.
        FIND ttGrid WHERE ttGrid.iX = i AND ttGrid.iY = j.
        ASSIGN
            iSizeMax = 300 - MAX(i,j)
            iPower   = 0.
        DO k = 0 TO iSizeMax:
            CREATE ttSquare.
            ASSIGN
                ttSquare.iX    = i
                ttSquare.iY    = j
                ttSquare.iSize = k + 1.
            jj = k.
            DO ii = 0 TO k - 1:
                FIND bttGrid WHERE bttGrid.iX = i + ii AND bttGrid.iY = j + jj.
                iPower = iPower + bttGrid.iPower.
            END.
            DO jj = 0 TO k:
                ii = k.
                FIND bttGrid WHERE bttGrid.iX = i + ii AND bttGrid.iY = j + jj.
                iPower = iPower + bttGrid.iPower.
            END.
            ttSquare.iPower = iPower.
        END.
    END.
END.
OUTPUT CLOSE.

FOR EACH ttSquare BY ttSquare.iPower DESCENDING:
    LEAVE.
END.

MESSAGE ETIME SKIP
    ttSquare.iX ttSquare.iY ttSquare.iSize ttSquare.iPower
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 21323360 -> 5h55! Could have implemented Kadane algorithm to speed up things a bit... */
/* 232 289 8 79 */

