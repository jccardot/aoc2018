/*
--- Day 2: Inventory Management System ---

--- Part Two ---

Confident that your list of box IDs is complete, you're ready to find the boxes full of prototype fabric.

The boxes will have IDs which differ by exactly one character at the same position in both strings. For example, given the following box IDs:

abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz

The IDs abcde and axcye are close, but they differ by two characters (the second and fourth). However, the IDs fghij and fguij differ by exactly one character, the third (h and u). Those must be the correct boxes.

What letters are common between the two correct box IDs? (In the example above, this is found by removing the differing character from either ID, producing fgij.)

*/
DEFINE VARIABLE c1    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c2    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCode AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLast AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNb   AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttCode NO-UNDO 
 FIELD iSeq  AS INTEGER    
 FIELD cCode AS CHARACTER  
 INDEX ix IS PRIMARY UNIQUE cCode
 INDEX ii IS UNIQUE iSeq.

DEFINE BUFFER bttCode FOR ttCode.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day2.txt.
REPEAT:
    IMPORT cCode.
    i = i + 1.
    CREATE ttCode.
    ASSIGN ttCode.iSeq  = i
           ttCode.cCode = cCode.
END.
INPUT CLOSE.

blkCode1:
FOR EACH ttCode:
    blkCode2:
    FOR EACH bttCode WHERE bttCode.iSeq > ttCode.iSeq:
        iNb = 0.
        blkChar:
        DO i = LENGTH(ttCode.cCode) TO 1 BY -1:
            ASSIGN
                c1 = SUBSTRING(ttCode.cCode,i,1)
                c2 = SUBSTRING(bttCode.cCode,i,1).
            IF c1 = c2 THEN NEXT blkChar.
            iNb = iNb + 1.
            IF iNb > 1 THEN NEXT blkCode2.
            iLast = i.
        END.
        IF iNb = 1 THEN LEAVE blkCode1.
    END.
END.

cCode = ttCode.cCode.
SUBSTRING(cCode, iLast, 1) = "".

MESSAGE ETIME SKIP
    cCode
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/* 631 */
/* qysdtrkloagnfozuwujmhrbvx */

