/*
--- Day 9: Marble Mania ---

--- Part Two ---

Amused by the speed of your answer, the Elves are curious:

What would the new winning Elf's score be if the number of the last marble were 100 times larger?

*/
DEFINE VARIABLE i              AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCurrentMarble AS INTEGER   NO-UNDO.
DEFINE VARIABLE iMarble        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iNext          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iNextMarble    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPrev          AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE ttMarble NO-UNDO
 FIELD id AS INTEGER
 FIELD iPrev AS INTEGER
 FIELD iNext AS INTEGER
 INDEX ix IS PRIMARY UNIQUE id.
DEFINE BUFFER nttMarble FOR ttMarble.
DEFINE BUFFER pttMarble FOR ttMarble.

DEFINE TEMP-TABLE ttPlayer NO-UNDO
 FIELD id AS INTEGER
 FIELD iScore AS INT64
 INDEX ix IS PRIMARY UNIQUE id
 INDEX ip iScore DESCENDING.

/* 9 players; last marble is worth 25 points */
/* &GLOBAL-DEFINE xiPlayers 9 */
/* &GLOBAL-DEFINE xiMarbles 25 */

/* My input: */
/* 473 players; last marble is worth 70904 points x 100 */                           
&GLOBAL-DEFINE xiPlayers 473
&GLOBAL-DEFINE xiMarbles 7090400

ETIME(YES).

ASSIGN
    iCurrentMarble = 0
    iNextMarble    = 0.

CREATE ttMarble.
ASSIGN ttMarble.id    = 0
       ttMarble.iNext = 0
       ttMarble.iPrev = 0.
RELEASE ttMarble.

DO i = 1 TO {&xiPlayers}:
    CREATE ttPlayer.
    ASSIGN ttPlayer.id = i.
END.

blk:
DO WHILE TRUE:
    FOR EACH ttPlayer BY ttPlayer.id:

        iNextMarble = iNextMarble + 1.

        IF iCurrentMarble > 0 AND iNextMarble MODULO 23 = 0 THEN DO:
            ttPlayer.iScore = ttPlayer.iScore + iNextMarble.

            /* find marble 7 marbles counter-clockwise */
            FIND ttMarble WHERE ttMarble.id = iCurrentMarble.
            DO iMarble = 1 TO 7:
                iPrev = ttMarble.iPrev.
                FIND ttMarble WHERE ttMarble.id = iPrev.
            END.
            /* add it to the player's score */
            ttPlayer.iScore = ttPlayer.iScore + ttMarble.id.

            /* remove it from the circle */
            FIND pttMarble WHERE pttMarble.id = ttMarble.iPrev.
            FIND nttMarble WHERE nttMarble.id = ttMarble.iNext.
            ASSIGN
                iCurrentMarble  = nttMarble.id
                pttMarble.iNext = nttMarble.id
                nttMarble.iPrev = pttMarble.id.
            DELETE ttMarble.
            
        END.
        ELSE DO:
            FIND nttMarble WHERE nttMarble.id = iCurrentMarble.
            FIND ttMarble WHERE ttMarble.id = nttMarble.iNext.
            FIND nttMarble WHERE nttMarble.id = ttMarble.iNext.

            iCurrentMarble = iNextMarble.

            ASSIGN
                ttMarble.iNext  = iCurrentMarble
                nttMarble.iPrev = iCurrentMarble
                iPrev           = ttMarble.id.
            
            CREATE ttMarble.
            ASSIGN ttMarble.id    = iCurrentMarble
                   ttMarble.iPrev = iPrev
                   ttMarble.iNext = nttMarble.id.
            RELEASE ttMarble.
        END.

        IF iCurrentMarble >= {&xiMarbles} THEN
            LEAVE blk.
    END.
END.

FOR EACH ttPlayer BY ttPlayer.iScore DESCENDING:
    LEAVE.
END.

/* DEFINE VARIABLE lcCircle AS LONGCHAR   NO-UNDO.      */
/* i = 0.                                               */
/* FIND ttMarble WHERE ttMarble.id = 0.                 */
/* DO WHILE TRUE:                                       */
/*     lcCircle = lcCircle + "," + STRING(ttMarble.id). */
/*     iNext = ttMarble.iNext.                          */
/*     FIND ttMarble WHERE ttMarble.id = iNext.         */
/*     i = i + 1.                                       */
/*     IF i >= {&xiMarbles} THEN LEAVE.                 */
/* END.                                                 */
/* lcCircle = SUBSTRING(lcCircle, 2).                   */

MESSAGE ETIME SKIP
    /* STRING(lcCircle) SKIP */
    ttPlayer.iScore
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 343974 */
/* 3038972494 */

