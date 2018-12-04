/*
--- Day 4: Repose Record ---

--- Part Two ---

Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. (In all other cases, any guard spent any minute asleep at most twice.)

What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 99 * 45 = 4455.)

*/
DEFINE VARIABLE c         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDate     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTime     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iGuard    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMinute   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSleep    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSleepMin AS INTEGER     EXTENT 60 NO-UNDO.
DEFINE VARIABLE iStartMin AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttEvent NO-UNDO
 FIELD dt      AS DATETIME   
 FIELD iMinute AS INTEGER    
 FIELD cEvent  AS CHARACTER  
 FIELD iGuard  AS INTEGER    
 INDEX ix IS PRIMARY UNIQUE dt.

DEFINE TEMP-TABLE ttGuard NO-UNDO
 FIELD iGuard        AS INTEGER  
 FIELD iShifts       AS INTEGER  
 FIELD iSleepTime    AS INTEGER  
 FIELD iMinute       AS INTEGER   EXTENT 60
 FIELD iSleepMin     AS INTEGER  
 FIELD iSleepMinFreq AS INTEGER  
 INDEX ix IS PRIMARY UNIQUE iGuard
 INDEX ist iSleepTime DESCENDING
 INDEX ism iSleepMinFreq DESCENDING.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day4.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    c = LEFT-TRIM(ENTRY(1, cLine, "]"), "[").
    ASSIGN
        cDate = ENTRY(1, c, " ")
        cTime = ENTRY(2, c, " ").
    CREATE ttEvent.
    ASSIGN
        ttEvent.dt = DATETIME(INTEGER(ENTRY(2,cDate,"-")),INTEGER(ENTRY(3,cDate,"-")),INTEGER(ENTRY(1,cDate,"-")),
                              INTEGER(ENTRY(1,cTime,":")),INTEGER(ENTRY(2,cTime,":")))
        ttEvent.iMinute = INTEGER(ENTRY(2,cTime,":"))
        ttEvent.cEvent = TRIM(ENTRY(2, cLine, "]"))
        .
END.
INPUT CLOSE.

FOR EACH ttEvent BY ttEvent.dt:
    IF ttEvent.cEvent BEGINS "Guard" THEN DO:
        iGuard = INTEGER(SUBSTRING(ENTRY(2, ttEvent.cEvent, " "), 2)).
        FIND ttGuard WHERE ttGuard.iGuard = iGuard NO-ERROR.
        IF NOT AVAILABLE ttGuard THEN DO:
            CREATE ttGuard.
            ASSIGN ttGuard.iGuard = iGuard.
        END.
        ttGuard.iShifts = ttGuard.iShifts + 1.
    END.
    ELSE IF ttEvent.cEvent = "falls asleep" THEN
        iStartMin = ttEvent.iMinute.
    ttEvent.iGuard = iGuard.
    IF ttEvent.cEvent = "wakes up" THEN DO:
        ttGuard.iSleepTime = ttGuard.iSleepTime + ttEvent.iMinute - iStartMin.
        DO i = iStartMin TO ttEvent.iMinute - 1:
            ttGuard.iMinute[i + 1] = ttGuard.iMinute[i + 1] + 1.
        END.
    END.
END.

FOR EACH ttGuard:
    DO i = 0 TO 59:
        IF ttGuard.iMinute[i + 1] > iSleep THEN DO:
            iSleep = ttGuard.iMinute[i + 1].
            iMinute = i.
        END.
    END.
    ASSIGN
        ttGuard.iSleepMin     = iMinute
        ttGuard.iSleepMinFreq = iSleep.
END.

FOR EACH ttGuard BY ttGuard.iSleepMinFreq DESCENDING:
    LEAVE.
END.

MESSAGE ETIME SKIP
    ttGuard.iGuard "*" ttGuard.iSleepMin "=" ttGuard.iGuard * ttGuard.iSleepMin
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 105 */
/* 2917 * 35 = 102095 */

