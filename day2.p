/*
--- Day 2: Inventory Management System ---

You stop falling through time, catch your breath, and check the screen on the device. "Destination reached. Current Year: 1518. Current Location: North Pole Utility Closet 83N10." You made it! Now, to find those anomalies.

Outside the utility closet, you hear footsteps and a voice. "...I'm not sure either. But now that so many people have chimneys, maybe he could sneak in that way?" Another voice responds, "Actually, we've been working on a new kind of suit that would let him fit through tight spaces like that. But, I heard that a few days ago, they lost the prototype fabric, the design plans, everything! Nobody on the team can even seem to remember important details of the project!"

"Wouldn't they have had enough fabric to fill several boxes in the warehouse? They'd be stored together, so the box IDs should be similar. Too bad it would take forever to search the warehouse for two similar box IDs..." They walk too far away to hear any more.

Late at night, you sneak to the warehouse - who knows what kinds of paradoxes you could cause if you were discovered - and use your fancy wrist device to quickly scan every box and produce a list of the likely candidates (your puzzle input).

To make sure you didn't miss any, you scan the likely candidate boxes again, counting the number that have an ID containing exactly two of any letter and then separately counting those with exactly three of any letter. You can multiply those two counts together to get a rudimentary checksum and compare it to what your device predicts.

For example, if you see the following box IDs:

    abcdef contains no letters that appear exactly two or three times.
    bababc contains two a and three b, so it counts for both.
    abbcde contains two b, but no letter appears exactly three times.
    abcccd contains three c, but no letter appears exactly two times.
    aabcdd contains two a and two d, but it only counts once.
    abcdee contains two e.
    ababab contains three a and three b, but it only counts once.

Of these box IDs, four of them contain a letter which appears exactly twice, and three of them contain a letter which appears exactly three times. Multiplying these together produces a checksum of 4 * 3 = 12.

What is the checksum for your list of box IDs?
*/
DEFINE VARIABLE c     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCode AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i2    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i3    AS INTEGER     NO-UNDO.
DEFINE VARIABLE l2 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l3 AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttChar NO-UNDO
 FIELD c AS CHARACTER
 FIELD iCount AS INTEGER
 INDEX ix IS PRIMARY UNIQUE c.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day2.txt.
REPEAT:
    IMPORT cCode.
    EMPTY TEMP-TABLE ttChar.
    DO i = LENGTH(cCode) TO 1 BY -1:
        c = SUBSTRING(cCode,i,1).
        FIND ttChar WHERE ttChar.c = c NO-ERROR.
        IF NOT AVAILABLE ttChar THEN DO:
            CREATE ttChar.
            ASSIGN ttChar.c = c.
        END.
        ttChar.iCount = ttChar.iCount + 1.
    END.
    ASSIGN
        l2 = NO
        l3 = NO.
    FOR EACH ttChar:
        CASE ttChar.iCount:
            WHEN 2 THEN l2 = YES.
            WHEN 3 THEN l3 = YES.
        END CASE.
    END.
    IF l2 THEN i2 = i2 + 1.
    IF l3 THEN i3 = i3 + 1.
END.
INPUT CLOSE.
    
MESSAGE ETIME SKIP
    i2 "*" i3 "=" i2 * i3
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 4980 */

