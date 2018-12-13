/*
--- Day 13: Mine Cart Madness ---

A crop of this size requires significant logistics to transport produce, soil, fertilizer, and so on. The Elves are very busy pushing things around in carts on some kind of rudimentary system of tracks they've come up with.

Seeing as how cart-and-track systems don't appear in recorded history for another 1000 years, the Elves seem to be making this up as they go along. They haven't even figured out how to avoid collisions yet.

You map out the tracks (your puzzle input) and see where you can help.

Tracks consist of straight paths (| and -), curves (/ and \), and intersections (+). Curves connect exactly two perpendicular pieces of track; for example, this is a closed loop:

/----\
|    |
|    |
\----/

Intersections occur when two perpendicular paths cross. At an intersection, a cart is capable of turning left, turning right, or continuing straight. Here are two loops connected by two intersections:

/-----\
|     |
|  /--+--\
|  |  |  |
\--+--/  |
   |     |
   \-----/

Several carts are also on the tracks. Carts always face either up (^), down (v), left (<), or right (>). (On your initial map, the track under each cart is a straight path matching the direction the cart is facing.)

Each time a cart has the option to turn (by arriving at any intersection), it turns left the first time, goes straight the second time, turns right the third time, and then repeats those directions starting again with left the fourth time, straight the fifth time, and so on. This process is independent of the particular intersection at which the cart has arrived - that is, the cart has no per-intersection memory.

Carts all move at the same speed; they take turns moving a single step at a time. They do this based on their current location: carts on the top row move first (acting from left to right), then carts on the second row move (again from left to right), then carts on the third row, and so on. Once each cart has moved one step, the process repeats; each of these loops is called a tick.

For example, suppose there are two carts on a straight track:

|  |  |  |  |
v  |  |  |  |
|  v  v  |  |
|  |  |  v  X
|  |  ^  ^  |
^  ^  |  |  |
|  |  |  |  |

First, the top cart moves. It is facing down (v), so it moves down one square. Second, the bottom cart moves. It is facing up (^), so it moves up one square. Because all carts have moved, the first tick ends. Then, the process repeats, starting with the first cart. The first cart moves down, then the second cart moves up - right into the first cart, colliding with it! (The location of the crash is marked with an X.) This ends the second and last tick.

Here is a longer example:

/->-\        
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   

/-->\        
|   |  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \->--/
  \------/   

/---v        
|   |  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-+>-/
  \------/   

/---\        
|   v  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-+->/
  \------/   

/---\        
|   |  /----\
| /->--+-\  |
| | |  | |  |
\-+-/  \-+--^
  \------/   

/---\        
|   |  /----\
| /-+>-+-\  |
| | |  | |  ^
\-+-/  \-+--/
  \------/   

/---\        
|   |  /----\
| /-+->+-\  ^
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /----<
| /-+-->-\  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /---<\
| /-+--+>\  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /--<-\
| /-+--+-v  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /-<--\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /<---\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-<--/
  \------/   

/---\        
|   |  v----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \<+--/
  \------/   

/---\        
|   |  /----\
| /-+--v-\  |
| | |  | |  |
\-+-/  ^-+--/
  \------/   

/---\        
|   |  /----\
| /-+--+-\  |
| | |  X |  |
\-+-/  \-+--/
  \------/   

After following their respective paths for a while, the carts eventually crash. To help prevent crashes, you'd like to know the location of the first crash. Locations are given in X,Y coordinates, where the furthest left column is X=0 and the furthest top row is Y=0:

           111
 0123456789012
0/---\        
1|   |  /----\
2| /-+--+-\  |
3| | |  X |  |
4\-+-/  \-+--/
5  \------/   

In this example, the location of the first crash is 7,3.

*/
DEFINE VARIABLE c      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTrack AS CHARACTER   EXTENT 150 NO-UNDO.
DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCart  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLine  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTick  AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttCart NO-UNDO
 FIELD id        AS INTEGER    
 FIELD ix        AS INTEGER    
 FIELD iy        AS INTEGER    
 FIELD idx       AS INTEGER    
 FIELD idy       AS INTEGER    
 FIELD cLastTurn AS CHARACTER   INITIAL "R"
 INDEX ix IS PRIMARY UNIQUE id
 INDEX ixy ix iy.

DEFINE BUFFER bttCart FOR ttCart.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day13.txt.
REPEAT:
    iLine = iLine + 1.
    IMPORT UNFORMATTED cTrack[iLine].
    /* detect carts */
    DO i = LENGTH(cTrack[iLine]) TO 1 BY -1:
        c = SUBSTRING(cTrack[iLine], i, 1).
        IF LOOKUP(c, "<,>,^,v") > 0 THEN
            RUN newCart(i, iLine, c).
    END.
END.
INPUT CLOSE.

RUN drawTracks.

/* now let's run the carts! */
blkRun:
DO WHILE TRUE:
    iTick = iTick + 1.
    blkCart:
    REPEAT PRESELECT EACH ttCart BY ttCart.ix BY ttCart.iy:
        FIND NEXT ttCart.
        /* what's in front of us? */
        ASSIGN
            ttCart.ix = ttCart.ix + ttCart.idx
            ttCart.iy = ttCart.iy + ttCart.idy.
        CASE SUBSTRING(cTrack[ttCart.iy], ttCart.ix, 1):
            /* WHEN "-" OR WHEN "|" THEN . */
            WHEN "\" THEN DO:
                IF   /* > */    idx = +1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = +1.
                ELSE /* < */ IF idx = -1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = -1.
                ELSE /* V */ IF idx = 0  AND idy = +1 THEN ASSIGN ttCart.idx = +1 ttCart.idy = 0.
                ELSE /* ^ */ IF idx = 0  AND idy = -1 THEN ASSIGN ttCart.idx = -1 ttCart.idy = 0.
                NEXT blkCart.
            END.
            WHEN "/" THEN DO:
                IF   /* > */    idx = +1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = -1.
                ELSE /* < */ IF idx = -1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = +1.
                ELSE /* V */ IF idx = 0  AND idy = +1 THEN ASSIGN ttCart.idx = -1 ttCart.idy = 0.
                ELSE /* ^ */ IF idx = 0  AND idy = -1 THEN ASSIGN ttCart.idx = +1 ttCart.idy = 0.
                NEXT blkCart.
            END.
            WHEN "+" THEN DO:
                CASE ttCart.cLastTurn:
                    WHEN "R" THEN DO: /* turn left */
                        ttCart.cLastTurn = "L".
                        IF   /* > */    idx = +1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = -1.
                        ELSE /* < */ IF idx = -1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = +1.
                        ELSE /* V */ IF idx = 0  AND idy = +1 THEN ASSIGN ttCart.idx = +1 ttCart.idy = 0.
                        ELSE /* ^ */ IF idx = 0  AND idy = -1 THEN ASSIGN ttCart.idx = -1 ttCart.idy = 0.
                    END.
                    WHEN "L" THEN DO: /* go straight */
                        ttCart.cLastTurn = "S".
                    END.
                    WHEN "S" THEN DO: /* turn right */
                        ttCart.cLastTurn = "R".
                        IF   /* > */    idx = +1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = +1.
                        ELSE /* < */ IF idx = -1 AND idy = 0  THEN ASSIGN ttCart.idx = 0  ttCart.idy = -1.
                        ELSE /* V */ IF idx = 0  AND idy = +1 THEN ASSIGN ttCart.idx = -1 ttCart.idy = 0.
                        ELSE /* ^ */ IF idx = 0  AND idy = -1 THEN ASSIGN ttCart.idx = +1 ttCart.idy = 0.
                    END.
                END CASE.
            END.
        END CASE.
        /* detect collision */
        IF CAN-FIND(FIRST bttCart WHERE bttCart.id <> ttCart.id AND bttCart.ix = ttCart.ix AND bttCart.iy = ttCart.iy) THEN
            LEAVE blkRun.
    END. /* blkCart: FOR EACH ttCart */
    RUN drawTracks.
END. /* blkRun: DO WHILE TRUE */

IF AVAILABLE ttCart THEN /* collision */
    RUN drawTracks.

MESSAGE ETIME SKIP
    iTick "ticks" SKIP
    iCart "carts" SKIP
    IF AVAILABLE ttCart THEN STRING(ttCart.ix - 1) + "," + STRING(ttCart.iy - 1) ELSE ""
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 126 */
/* 124 ticks */
/* 17 carts */
/* 143,43 */

PROCEDURE newCart:
    DEFINE INPUT  PARAMETER pix AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piy AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcC AS CHARACTER   NO-UNDO.

    iCart = iCart + 1.
    CREATE ttCart.
    ASSIGN ttCart.id = iCart
           ttCart.ix = pix
           ttCart.iy = piy.
    /* clean up tracks - remove carts characters */
    CASE pcC:
        WHEN ">" THEN ASSIGN ttCart.idx = +1 ttCart.idy = 0  SUBSTRING(cTrack[iLine],i,1) = "-".
        WHEN "<" THEN ASSIGN ttCart.idx = -1 ttCart.idy = 0  SUBSTRING(cTrack[iLine],i,1) = "-".
        WHEN "v" THEN ASSIGN ttCart.idx = 0  ttCart.idy = +1 SUBSTRING(cTrack[iLine],i,1) = "|".
        WHEN "^" THEN ASSIGN ttCart.idx = 0  ttCart.idy = -1 SUBSTRING(cTrack[iLine],i,1) = "|".
    END CASE.

END PROCEDURE.

PROCEDURE drawTracks:

    RETURN. /* do not draw ;) */

    DEFINE BUFFER ttCart FOR ttCart.
    OUTPUT TO c:/temp/track.txt APPEND.
    PUT UNFORMATTED "Tick " iTick SKIP.
    DO i = 1 TO 150:
        c = cTrack[i].
        IF c = "" THEN LEAVE.
        FOR EACH ttCart WHERE ttCart.iy = i:
            SUBSTRING(c, ttCart.ix, 1) =
                IF CAN-FIND(FIRST bttCart WHERE bttCart.id <> ttCart.id AND bttCart.ix = ttCart.ix AND bttCart.iy = ttCart.iy) THEN "X"
                ELSE IF idx = +1 AND idy = 0  THEN ">"
                ELSE IF idx = -1 AND idy = 0  THEN "<"
                ELSE IF idx = 0  AND idy = -1 THEN "^"
                ELSE IF idx = 0  AND idy = +1 THEN "V"
                ELSE "@".
        END.
        PUT UNFORMATTED c SKIP.
    END.
    PUT UNFORMATTED SKIP(1).
    OUTPUT CLOSE.
END PROCEDURE.
