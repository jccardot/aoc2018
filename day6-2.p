/*
--- Day 6: Chronal Coordinates ---

--- Part Two ---

On the other hand, if the coordinates are safe, maybe the best you can do is try to find a region near as many coordinates as possible.

For example, suppose you want the sum of the Manhattan distance to all of the coordinates to be less than 32. For each location, add up the distances to all of the given coordinates; if the total of those distances is less than 32, that location is within the desired region. Using the same coordinates as above, the resulting region looks like this:

..........
.A........
..........
...###..C.
..#D###...
..###E#...
.B.###....
..........
..........
........F.

In particular, consider the highlighted location 4,3 located at the top middle of the region. Its calculation is as follows, where abs() is the absolute value function:

    Distance to coordinate A: abs(4-1) + abs(3-1) =  5
    Distance to coordinate B: abs(4-1) + abs(3-6) =  6
    Distance to coordinate C: abs(4-8) + abs(3-3) =  4
    Distance to coordinate D: abs(4-3) + abs(3-4) =  2
    Distance to coordinate E: abs(4-5) + abs(3-5) =  3
    Distance to coordinate F: abs(4-8) + abs(3-9) = 10
    Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30

Because the total distance to all coordinates (30) is less than 32, the location is within the region.

This region, which also includes coordinates D and E, has a total size of 16.

Your actual region will need to be much larger than this example, though, instead including all locations with a total distance of less than 10000.

What is the size of the region containing all locations which have a total distance to all given coordinates of less than 10000?
    
*/
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iDist         AS INTEGER     NO-UNDO.
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

DEFINE VARIABLE iRegionSize AS INTEGER     NO-UNDO.

DO j = iMinY TO iMaxY:
    DO i = iMinX TO iMaxX:
        CREATE ttMap.
        ASSIGN ttMap.ix = i
               ttMap.iy = j.
        ASSIGN
            iDist = 0.
        FOR EACH ttPoint:
            iDist = iDist + ABSOLUTE(ttMap.ix - ttPoint.ix) + ABSOLUTE(ttMap.iy - ttPoint.iy).
        END.
        IF iDist < 10000 THEN
            iRegionSize = iRegionSize + 1.
        ASSIGN
            ttMap.iClosestPointDist = iDist.
    END.
END.

MESSAGE ETIME SKIP
    iRegionSize
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 31341 */
/* 40134 */

