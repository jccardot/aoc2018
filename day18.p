/*
--- Day 18: Settlers of The North Pole ---

On the outskirts of the North Pole base construction project, many Elves are collecting lumber.

The lumber collection area is 50 acres by 50 acres; each acre can be either open ground (.), trees (|), or a lumberyard (#). You take a scan of the area (your puzzle input).

Strange magic is at work here: each minute, the landscape looks entirely different. In exactly one minute, an open acre can fill with trees, a wooded acre can be converted to a lumberyard, or a lumberyard can be cleared to open ground (the lumber having been sent to other projects).

The change to each acre is based entirely on the contents of that acre as well as the number of open, wooded, or lumberyard acres adjacent to it at the start of each minute. Here, "adjacent" means any of the eight acres surrounding that acre. (Acres on the edges of the lumber collection area might have fewer than eight adjacent acres; the missing acres aren't counted.)

In particular:

    An open acre will become filled with trees if three or more adjacent acres contained trees. Otherwise, nothing happens.
    An acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards. Otherwise, nothing happens.
    An acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees. Otherwise, it becomes open.

These changes happen across all acres simultaneously, each of them using the state of all acres at the beginning of the minute and changing to their new form by the end of that same minute. Changes that happen during the minute don't affect each other.

For example, suppose the lumber collection area is instead only 10 by 10 acres with this initial configuration:

Initial state:
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.

After 1 minute:
.......##.
......|###
.|..|...#.
..|#||...#
..##||.|#|
...#||||..
||...|||..
|||||.||.|
||||||||||
....||..|.

After 2 minutes:
.......#..
......|#..
.|.|||....
..##|||..#
..###|||#|
...#|||||.
|||||||||.
||||||||||
||||||||||
.|||||||||

After 3 minutes:
.......#..
....|||#..
.|.||||...
..###|||.#
...##|||#|
.||##|||||
||||||||||
||||||||||
||||||||||
||||||||||

After 4 minutes:
.....|.#..
...||||#..
.|.#||||..
..###||||#
...###||#|
|||##|||||
||||||||||
||||||||||
||||||||||
||||||||||

After 5 minutes:
....|||#..
...||||#..
.|.##||||.
..####|||#
.|.###||#|
|||###||||
||||||||||
||||||||||
||||||||||
||||||||||

After 6 minutes:
...||||#..
...||||#..
.|.###|||.
..#.##|||#
|||#.##|#|
|||###||||
||||#|||||
||||||||||
||||||||||
||||||||||

After 7 minutes:
...||||#..
..||#|##..
.|.####||.
||#..##||#
||##.##|#|
|||####|||
|||###||||
||||||||||
||||||||||
||||||||||

After 8 minutes:
..||||##..
..|#####..
|||#####|.
||#...##|#
||##..###|
||##.###||
|||####|||
||||#|||||
||||||||||
||||||||||

After 9 minutes:
..||###...
.||#####..
||##...##.
||#....###
|##....##|
||##..###|
||######||
|||###||||
||||||||||
||||||||||

After 10 minutes:
.||##.....
||###.....
||##......
|##.....##
|##.....##
|##....##|
||##.####|
||#####|||
||||#|||||
||||||||||

After 10 minutes, there are 37 wooded acres and 31 lumberyards. Multiplying the number of wooded acres by the number of lumberyards gives the total resource value after ten minutes: 37 * 31 = 1147.

What will the total resource value of the lumber collection area be after 10 minutes?

*/
&GLOBAL-DEFINE xiMinutes 10

&GLOBAL-DEFINE xcOpen       "."
&GLOBAL-DEFINE xcTrees      "|"
&GLOBAL-DEFINE xcLumberyard "#"

DEFINE VARIABLE cAcre        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iAcre        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLine        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLumberyards AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMinute      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTrees       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iWidth       AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttLumber NO-UNDO
 FIELD iLine   AS INTEGER    
 FIELD lActive AS LOGICAL    
 FIELD cLumber AS CHARACTER  
 INDEX ix IS PRIMARY iLine lActive.
DEFINE BUFFER bttLumber FOR ttLumber.
DEFINE BUFFER pttLumber FOR ttLumber.
DEFINE BUFFER nttLumber FOR ttLumber.

FUNCTION getAdjacent RETURNS INTEGER ( piAcre AS INTEGER, pcType AS CHARACTER ):
    DEFINE VARIABLE iAcre  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER   NO-UNDO.

    IF AVAILABLE pttLumber THEN DO iAcre = MAXIMUM(1, piAcre - 1) TO MINIMUM(iWidth, piAcre + 1):
        IF SUBSTRING(pttLumber.cLumber, iAcre, 1) = pcType THEN
            iCount = iCount + 1.
    END.
    DO iAcre = MAXIMUM(1, piAcre - 1) TO MINIMUM(iWidth, piAcre + 1):
        IF iAcre = piAcre THEN NEXT.
        IF SUBSTRING(ttLumber.cLumber, iAcre, 1) = pcType THEN
            iCount = iCount + 1.
    END.
    IF AVAILABLE nttLumber THEN DO iAcre = MAXIMUM(1, piAcre - 1) TO MINIMUM(iWidth, piAcre + 1):
        IF SUBSTRING(nttLumber.cLumber, iAcre, 1) = pcType THEN
            iCount = iCount + 1.
    END.
    RETURN iCount.
END FUNCTION.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day18.txt.
REPEAT:
    iLine = iLine + 1.
    CREATE ttLumber.
    ASSIGN ttLumber.iLine   = iLine
           ttLumber.lActive = YES.
    IMPORT UNFORMATTED ttLumber.cLumber.
    IF iWidth = 0 THEN
        iWidth = LENGTH(ttLumber.cLumber).

    CREATE ttLumber.
    ASSIGN ttLumber.iLine   = iLine
           ttLumber.lActive = NO.
END.
DELETE ttLumber.
INPUT CLOSE.

RUN drawLumber.

DO iMinute = 1 TO {&xiMinutes}:
    FOR EACH ttLumber WHERE ttLumber.iLine > 0 AND ttLumber.lActive = YES:
        FIND pttLumber WHERE pttLumber.iLine = ttLumber.iLine - 1 AND pttLumber.lActive = YES NO-ERROR.
        FIND nttLumber WHERE nttLumber.iLine = ttLumber.iLine + 1 AND nttLumber.lActive = YES NO-ERROR.
        FIND bttLumber WHERE bttLumber.iLine = ttLumber.iLine AND bttLumber.lActive = NO.
        bttLumber.cLumber = ttLumber.cLumber.
        DO iAcre = iWidth TO 1 BY -1:
            cAcre = SUBSTRING(ttLumber.cLumber, iAcre, 1).
            CASE cAcre:
                WHEN {&xcOpen} THEN IF getAdjacent(iAcre, {&xcTrees}) >= 3 THEN
                    SUBSTRING(bttLumber.cLumber, iAcre, 1) = {&xcTrees}.
                WHEN {&xcTrees} THEN IF getAdjacent(iAcre, {&xcLumberyard}) >= 3 THEN
                    SUBSTRING(bttLumber.cLumber, iAcre, 1) = {&xcLumberyard}.
                WHEN {&xcLumberyard} THEN IF getAdjacent(iAcre, {&xcLumberyard}) = 0
                                          OR getAdjacent(iAcre, {&xcTrees}) = 0 THEN
                    SUBSTRING(bttLumber.cLumber, iAcre, 1) = {&xcOpen}.
            END CASE.
        END.
    END.
    REPEAT PRESELECT EACH ttLumber:
        FIND NEXT ttLumber.
        ttLumber.lActive = NOT ttLumber.lActive.
    END.
    RUN drawLumber.
END.

FOR EACH ttLumber WHERE ttLumber.iLine > 0 AND ttLumber.lActive = YES:
    DO iAcre = iWidth TO 1 BY -1:
        cAcre = SUBSTRING(ttLumber.cLumber, iAcre, 1).
        IF cAcre = {&xcTrees} THEN
            iTrees = iTrees + 1.
        ELSE IF cAcre = {&xcLumberyard} THEN
            iLumberyards = iLumberyards + 1.
    END.
END.

MESSAGE ETIME SKIP
    iTrees iLumberyards SKIP
    iTrees * iLumberyards
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
     
/* 1201 */
/* 837 605 */
/* 506385 */

PROCEDURE drawLumber:
    OUTPUT TO c:/temp/lumber.txt APPEND.
    PUT UNFORMATTED "Minute: " iMinute SKIP.
    FOR EACH ttLumber WHERE ttLumber.iLine > 0 AND ttLumber.lActive = YES:
        PUT UNFORMATTED ttLumber.cLumber SKIP.
    END.
    PUT UNFORMATTED FILL("=", iWidth) SKIP(1).
    OUTPUT CLOSE.
END PROCEDURE.
