/*
--- Day 7: The Sum of Its Parts ---

--- Part Two ---

As you're about to begin construction, four of the Elves offer to help. "The sun will set soon; it'll go faster if we work together." Now, you need to account for multiple people working on steps simultaneously. If multiple steps are available, workers should still begin them in alphabetical order.

Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds. No time is required between steps.

To simplify things for the example, however, suppose you only have help from one Elf (a total of two workers) and that each step takes 60 fewer seconds (so that step A takes 1 second and step Z takes 26 seconds). Then, using the same instructions as above, this is how each second would be spent:

Second   Worker 1   Worker 2   Done
   0        C          .        
   1        C          .        
   2        C          .        
   3        A          F       C
   4        B          F       CA
   5        B          F       CA
   6        D          F       CAB
   7        D          F       CAB
   8        D          F       CAB
   9        D          .       CABF
  10        E          .       CABFD
  11        E          .       CABFD
  12        E          .       CABFD
  13        E          .       CABFD
  14        E          .       CABFD
  15        .          .       CABFDE

Each row represents one second of time. The Second column identifies how many seconds have passed as of the beginning of that second. Each worker column shows the step that worker is currently doing (or . if they are idle). The Done column shows completed steps.

Note that the order of the steps has changed; this is because steps now take time to finish and multiple workers can begin multiple steps simultaneously.

In this example, it would take 15 seconds for two workers to complete these steps.

With 5 workers and the 60+ second step durations described above, how long will it take to complete all of the steps?
    
*/

&GLOBAL-DEFINE xiNumWorkers 5

DEFINE VARIABLE cLine           AS CHARACTER   EXTENT 10 NO-UNDO.
DEFINE VARIABLE cStep           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSteps          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSteps          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTime           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iWorker         AS INTEGER     NO-UNDO.
DEFINE VARIABLE lStep           AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttStep NO-UNDO
 FIELD id    AS CHARACTER  
 FIELD lDone AS LOGICAL    
 INDEX ix IS PRIMARY UNIQUE id.

DEFINE TEMP-TABLE ttOrder NO-UNDO
 FIELD cStepFrom AS CHARACTER  
 FIELD cStepTo   AS CHARACTER  
 FIELD lReady    AS LOGICAL    
 INDEX ix IS PRIMARY UNIQUE cStepFrom cStepTo.

DEFINE TEMP-TABLE ttWorker NO-UNDO
 FIELD iBusyTime    AS INTEGER    
 FIELD cOngoingStep AS CHARACTER  
 INDEX ix iBusyTime.

DEFINE BUFFER bttOrder FOR ttOrder.

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day7.txt.
REPEAT:
    IMPORT DELIMITER " " cLine.
    /* cLine[2] before cLine[8] */
    FIND ttStep WHERE ttStep.id = cLine[2] NO-ERROR.
    IF NOT AVAILABLE ttStep THEN DO:
        CREATE ttStep.
        ASSIGN ttStep.id = cLine[2].
    END.
    FIND ttStep WHERE ttStep.id = cLine[8] NO-ERROR.
    IF NOT AVAILABLE ttStep THEN DO:
        CREATE ttStep.
        ASSIGN ttStep.id = cLine[8].
    END.
    FIND ttOrder WHERE ttOrder.cStepFrom = cLine[2] AND ttOrder.cStepTo = cLine[8] NO-ERROR.
    IF NOT AVAILABLE ttOrder THEN DO:
        CREATE ttOrder.
        ASSIGN ttOrder.cStepFrom = cLine[2]
               ttOrder.cStepTo   = cLine[8].
    END.
END.
INPUT CLOSE.

FOR EACH ttStep:
    iSteps = iSteps + 1.
END.

/* find start(s) and create corresponding ttOrders */
FOR EACH ttStep WHERE BY ttStep.id:
    IF NOT CAN-FIND(FIRST ttOrder WHERE ttOrder.cStepTo = ttStep.id) THEN DO:
        CREATE ttOrder.
        ASSIGN ttOrder.cStepTo = ttStep.id
               ttOrder.lReady  = YES.
    END.
END.

/* create the workers */
DO iWorker = 1 TO {&xiNumWorkers}:
    CREATE ttWorker.
    ASSIGN ttWorker.iBusyTime = 0.
END.

/* then process ready links */
blk:
DO WHILE iSteps > 0 OR CAN-FIND(FIRST ttWorker WHERE ttWorker.iBusyTime > 0):

    FOR EACH ttWorker WHERE ttWorker.iBusyTime = 0: /* for each available worker... */

        /* get next available step */
        IF iSteps > 0 THEN DO:
            FOR EACH ttOrder WHERE ttOrder.lReady = YES
               ,FIRST ttStep WHERE ttStep.id = ttOrder.cStepTo AND ttStep.lDone = NO
                BY ttOrder.cStepTo:

                IF CAN-FIND(FIRST bttOrder WHERE bttOrder.cStepTo = ttOrder.cStepTo AND bttOrder.lReady = NO) THEN
                    NEXT.
                
                ttStep.lDone = ? /* means ongoing */.

                LEAVE.
            END.

            IF AVAILABLE ttStep THEN ASSIGN
                ttWorker.cOngoingStep = ttStep.id
                ttWorker.iBusyTime    = 60 + ASC(ttStep.id) - 64.
        END.
    END. /* for each available worker... */

    iTime = iTime + 1.

    FOR EACH ttWorker WHERE ttWorker.iBusyTime > 0:
        ttWorker.iBusyTime = ttWorker.iBusyTime - 1.
        IF ttWorker.iBusyTime = 0 THEN DO:
            cSteps = cSteps + ttWorker.cOngoingStep.
            FIND ttStep WHERE ttStep.id = ttWorker.cOngoingStep.
            FOR EACH bttOrder WHERE bttOrder.cStepFrom = ttWorker.cOngoingStep:
                bttOrder.lReady = YES.
            END.
            ASSIGN
                iSteps                = iSteps - 1
                ttStep.lDone          = YES
                ttWorker.cOngoingStep = "".
        END.
    END.

END.

MESSAGE ETIME SKIP
    cSteps SKIP
    iTime
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 5752 */
/* LRVAGPZHFOTCKWENBXIMSUDJQY */
/* 936 */
    
