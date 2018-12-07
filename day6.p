/*
--- Day 6: Chronal Coordinates ---

The device on your wrist beeps several times, and once again you feel like you're falling.

"Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:

1, 1
1, 6
8, 3
3, 4
5, 5
8, 9

If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:

..........
.A........
..........
........C.
...D......
.....E....
.B........
..........
..........
........F.

This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:

aaaaa.cccc
aAaaa.cccc
aaaddecccc
aadddeccCc
..dDdeeccc
bb.deEeecc
bBb.eeee..
bbb.eeefff
bbb.eeffff
bbb.ffffFf

Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.

In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.

What is the size of the largest area that isn't infinite?
    
*/
DEFINE VARIABLE c             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iClosestPoint AS INTEGER     NO-UNDO.
DEFINE VARIABLE iDist         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iDistMin      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxX         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxY         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMinX         AS INTEGER     INITIAL 10000 NO-UNDO.
DEFINE VARIABLE iMinY         AS INTEGER     INITIAL 10000 NO-UNDO.
DEFINE VARIABLE j             AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttPoint NO-UNDO
 FIELD id    AS INTEGER  
 FIELD ix    AS INTEGER  
 FIELD iy    AS INTEGER  
 FIELD iArea AS INTEGER  
 INDEX ipk IS PRIMARY UNIQUE id
 INDEX ixy ix iy
 INDEX ia iArea DESCENDING.

DEFINE TEMP-TABLE ttMap NO-UNDO
 FIELD ix                AS INTEGER  
 FIELD iy                AS INTEGER  
 FIELD iClosestPoint     AS INTEGER  
 FIELD iClosestPointDist AS INTEGER  
 INDEX ixy ix iy.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day6.txt.
REPEAT:
    i = i + 1.
    CREATE ttPoint.
    ttPoint.id = i.
    IMPORT DELIMITER "," ttPoint.ix ttPoint.iy.
    IF iMaxX < ttPoint.ix THEN iMaxX = ttPoint.ix.
    IF iMinX > ttPoint.ix THEN iMinX = ttPoint.ix.
    IF iMaxY < ttPoint.iy THEN iMaxY = ttPoint.iy.
    IF iMinY > ttPoint.iy THEN iMinY = ttPoint.iy.
END.
INPUT CLOSE.
DELETE ttPoint.

ASSIGN
    iMinX = iMinX - 1
    iMaxX = iMaxX + 1

    iMinY = iMinY - 1
    iMaxY = iMaxY + 1.

DO j = iMinY TO iMaxY:
    DO i = iMinX TO iMaxX:
        CREATE ttMap.
        ASSIGN ttMap.ix = i
               ttMap.iy = j.
        ASSIGN
            iClosestPoint = 0
            iDistMin      = 20000.
        FOR EACH ttPoint:
            iDist = ABSOLUTE(ttMap.ix - ttPoint.ix) + ABSOLUTE(ttMap.iy - ttPoint.iy).
            IF iDist < iDistMin THEN ASSIGN
                iClosestPoint = ttPoint.id
                iDistMin      = iDist.
            ELSE IF iDist = iDistMin THEN
                iClosestPoint = ?.
        END.
        ASSIGN
            ttMap.iClosestPoint     = iClosestPoint
            ttMap.iClosestPointDist = iDist.
        IF iClosestPoint <> ? THEN DO:
            FIND ttPoint WHERE ttPoint.id = iClosestPoint.
            ttPoint.iArea = ttPoint.iArea + 1.
        END.
    END.
END.

FOR EACH ttMap
    WHERE ttMap.ix = iMinX  OR ttMap.ix = iMaxX OR ttMap.iy = iMinY OR ttMap.iy = iMaxY
   ,FIRST ttPoint WHERE ttPoint.id = ttMap.iClosestPoint
    BREAK BY ttPoint.id:

    IF FIRST-OF(ttPoint.id) THEN
        ttPoint.iArea = ?.
END.

/* DEFINE VARIABLE cMap AS LONGCHAR   NO-UNDO.                                                                 */
/* DO j = iMinY TO iMaxY:                                                                                      */
/*     DO i = iMinX TO iMaxX:                                                                                  */
/*         FIND ttPoint WHERE ttPoint.ix = i AND ttPoint.iy = j NO-ERROR.                                      */
/*         IF AVAILABLE ttPoint THEN                                                                           */
/*             cMap = cMap + CHR(64 + ttPoint.id MODULO 31).                                                   */
/*         ELSE DO:                                                                                            */
/*             FIND ttMap WHERE ttMap.ix = i AND ttMap.iy = j.                                                 */
/*             cMap = cMap + IF ttMap.iClosestPoint = ? THEN "." ELSE CHR(96 + ttMap.iClosestPoint MODULO 31). */
/*         END.                                                                                                */
/*     END.                                                                                                    */
/*     cMap = cMap + "~n".                                                                                     */
/* END.                                                                                                        */

FOR EACH ttPoint WHERE ttPoint.iArea <> ? BY ttPoint.iArea DESCENDING:
    LEAVE.
END.

MESSAGE ETIME SKIP
    /* iMinX iMaxX "/" iMinY iMaxY SKIP */
    /* cMap SKIP */
    ttPoint.id CHR(64 + ttPoint.id MODULO 31) ttPoint.iArea
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* COPY-LOB cMap TO FILE "c:/temp/map.txt". */

/* 28423 */
/* 22 V 3687 */

/* example:
15 
aaaaa.cccc
aAaaa.cccc
aaaddecccc
aadddeccCc
..dDdeeccc
bb.deEeecc
bBb.eeee..
bbb.eeefff
bbb.eeffff
bbb.ffffFf
bbb.ffffff

5 E 17
*/
