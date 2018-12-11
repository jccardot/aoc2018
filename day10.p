/*
--- Day 10: The Stars Align ---

It's no use; your navigation system simply isn't capable of providing walking directions in the arctic circle, and certainly not in 1018.

The Elves suggest an alternative. In times like these, North Pole rescue operations will arrange points of light in the sky to guide missing Elves back to base. Unfortunately, the message is easy to miss: the points move slowly enough that it takes hours to align them, but have so much momentum that they only stay aligned for a second. If you blink at the wrong time, it might be hours before another message appears.

You can see these points of light floating in the distance, and record their position in the sky and their velocity, the relative change in position per second (your puzzle input). The coordinates are all given from your perspective; given enough time, those positions and velocities will move the points into a cohesive message!

Rather than wait, you decide to fast-forward the process and calculate what the points will eventually spell.

For example, suppose you note the following points:

position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>

Each line represents one point. Positions are given as <X, Y> pairs: X represents how far left (negative) or right (positive) the point appears, while Y represents how far up (negative) or down (positive) the point appears.

At 0 seconds, each point has the position given. Each second, each point's velocity is added to its position. So, a point with velocity <1, -2> is moving to the right, but is moving upward twice as quickly. If this point's initial position were <3, 9>, after 3 seconds, its position would become <6, 3>.

Over time, the points listed above would move like this:

Initially:
........#.............
................#.....
.........#.#..#.......
......................
#..........#.#.......#
...............#......
....#.................
..#.#....#............
.......#..............
......#...............
...#...#.#...#........
....#..#..#.........#.
.......#..............
...........#..#.......
#...........#.........
...#.......#..........

After 1 second:
......................
......................
..........#....#......
........#.....#.......
..#.........#......#..
......................
......#...............
....##.........#......
......#.#.............
.....##.##..#.........
........#.#...........
........#...#.....#...
..#...........#.......
....#.....#.#.........
......................
......................

After 2 seconds:
......................
......................
......................
..............#.......
....#..#...####..#....
......................
........#....#........
......#.#.............
.......#...#..........
.......#..#..#.#......
....#....#.#..........
.....#...#...##.#.....
........#.............
......................
......................
......................

After 3 seconds:
......................
......................
......................
......................
......#...#..###......
......#...#...#.......
......#...#...#.......
......#####...#.......
......#...#...#.......
......#...#...#.......
......#...#...#.......
......#...#..###......
......................
......................
......................
......................

After 4 seconds:
......................
......................
......................
............#.........
........##...#.#......
......#.....#..#......
.....#..##.##.#.......
.......##.#....#......
...........#....#.....
..............#.......
....#......#...#......
.....#.....##.........
...............#......
...............#......
......................
......................

After 3 seconds, the message appeared briefly: HI. Of course, your message will be much longer and will take many more seconds to appear.

*/
DEFINE VARIABLE cLine   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSky    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSecond AS INTEGER     NO-UNDO.
DEFINE VARIABLE ixMax   AS INTEGER     NO-UNDO.
DEFINE VARIABLE ixMin   AS INTEGER     INITIAL 999999 NO-UNDO.
DEFINE VARIABLE iyMax   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iyMin   AS INTEGER     INITIAL 999999 NO-UNDO.
DEFINE VARIABLE j       AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttStar NO-UNDO
 FIELD i  AS INTEGER  
 FIELD x  AS INTEGER  
 FIELD y  AS INTEGER  
 FIELD vx AS INTEGER  
 FIELD vy AS INTEGER  
 INDEX ix IS PRIMARY x y
 INDEX ii IS UNIQUE i.

DEFINE BUFFER bttStar FOR ttStar.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day10.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    i = i + 1.
    CREATE ttStar.
    ASSIGN
        ttStar.i  = i
        ttStar.x  = INTEGER(ENTRY(2, ENTRY(1, cLine), "<"))
        ttStar.y  = INTEGER(ENTRY(1, ENTRY(2, cLine), ">"))
        ttStar.vx = INTEGER(ENTRY(2, ENTRY(2, cLine), "<"))
        ttStar.vy = INTEGER(ENTRY(1, ENTRY(3, cLine), ">"))
        ixMin     = MINIMUM(ixMin, ttStar.x)
        ixMax     = MAXIMUM(ixMax, ttStar.x)
        iyMin     = MINIMUM(iyMin, ttStar.y)
        iyMax     = MAXIMUM(iyMax, ttStar.y)
        .
END.
INPUT CLOSE.

DO WHILE TRUE:
    ASSIGN
        ixMin = 999999
        ixMax = 0
        iyMin = 999999
        iyMax = 0
        iSecond = iSecond + 1
        .
    REPEAT PRESELECT EACH ttStar:
        FIND NEXT ttStar.
        ASSIGN
            ttStar.x = ttStar.x + ttStar.vx
            ttStar.y = ttStar.y + ttStar.vy
            ixMin     = MINIMUM(ixMin, ttStar.x)
            ixMax     = MAXIMUM(ixMax, ttStar.x)
            iyMin     = MINIMUM(iyMin, ttStar.y)
            iyMax     = MAXIMUM(iyMax, ttStar.y)
            .
    END.
    IF ixMax - ixMin < 100 THEN DO:
        OUTPUT TO c:/temp/sky.txt APPEND.
        PUT UNFORMATTED "Second " iSecond SKIP.
        DO j = iyMin TO iyMax:
            DO i = ixMin TO ixMax:
                IF CAN-FIND(FIRST bttStar WHERE bttStar.x = i AND bttStar.y = j) THEN
                    PUT UNFORMATTED "#".
                ELSE
                    PUT UNFORMATTED ".".
            END.
            PUT UNFORMATTED SKIP.
        END.
        PUT UNFORMATTED SKIP FILL("=", 80) SKIP.
        OUTPUT CLOSE.
    END.
    /* Detect letters --> 4 points aligned */
    FOR EACH ttStar BY ttStar.x:
        IF    CAN-FIND(bttStar WHERE bttStar.x = ttStar.x + 1 AND bttStar.y = ttStar.y)
          AND CAN-FIND(bttStar WHERE bttStar.x = ttStar.x + 2 AND bttStar.y = ttStar.y)
          AND CAN-FIND(bttStar WHERE bttStar.x = ttStar.x + 3 AND bttStar.y = ttStar.y)
          /* AND CAN-FIND(bttStar WHERE bttStar.x = ttStar.x + 4 AND bttStar.y = ttStar.y) */
        THEN DO:
            /* OUTPUT TO c:/temp/sky.txt. */
            /* DO j = iyMin TO iyMax: */
                /* DO i = ixMin TO ixMax: */
                    /* IF CAN-FIND(FIRST bttStar WHERE bttStar.x = i AND bttStar.y = j) THEN */
                        /* PUT UNFORMATTED "#". */
                    /* ELSE */
                        /* PUT UNFORMATTED ".". */
                /* END. */
                /* PUT UNFORMATTED SKIP. */
            /* END. */
            /* OUTPUT CLOSE. */
            /* ********** */
            /* cSky = "". */
            /* DO j = iyMin TO iyMax: */
                /* DO i = ixMin TO ixMax: */
                    /* IF CAN-FIND(FIRST ttStar WHERE ttStar.x = i AND ttStar.y = j) THEN */
                        /* cSky = cSky + "#". */
                    /* ELSE */
                        /* cSky = cSky + ".". */
                /* END. */
                /* cSky = cSky + "~n". */
            /* END. */
            MESSAGE ETIME SKIP "Check c:/temp/sky.txt" SKIP cSky SKIP
                "ttStar.x" ttStar.x SKIP
                "ttStar.y" ttStar.y SKIP
                "ixMin"    ixMin    SKIP
                "ixMax"    ixMax    SKIP
                "iyMin"    iyMin    SKIP
                "iyMax"    iyMax    SKIP
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
        END.
    END.
END.

MESSAGE ETIME SKIP

    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* GFANEHKJ */
/* second 10086 */
