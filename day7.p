/*
--- Day 7: The Sum of Its Parts ---

You find yourself standing on a snow-covered coastline; apparently, you landed a little off course. The region is too hilly to see the North Pole from here, but you do spot some Elves that seem to be trying to unpack something that washed ashore. It's quite cold out, so you decide to risk creating a paradox by asking them for directions.

"Oh, are you the search party?" Somehow, you can understand whatever Elves from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the device on your wrist also be a translator? "Those clothes don't look very warm; take this." They hand you a heavy coat.

"We do need to find our way back to the North Pole, but we have higher priorities at the moment. You see, believe it or not, this box contains something that will solve all of Santa's transportation problems - at least, that's what it looks like from the pictures in the instructions." It doesn't seem like they can read whatever language it's in, but you can: "Sleigh kit. Some assembly required."

"'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at once!" They start excitedly pulling more parts out of the box.

The instructions specify a series of steps and requirements about which steps must be finished before others can begin (your puzzle input). Each step is designated by a single letter. For example, suppose you have the following instructions:

Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.

Visually, these requirements look like this:


  -->A--->B--
 /    \      \
C      -->D----->E
 \           /
  ---->F-----

Your first goal is to determine the order in which the steps should be completed. If more than one step is ready, choose the step which is first alphabetically. In this example, the steps would be completed as follows:

    Only C is available, and so it is done first.
    Next, both A and F are available. A is first alphabetically, so it is done next.
    Then, even though F was available earlier, steps B and D are now also available, and B is the first alphabetically of the three.
    After that, only D and F are available. E is not available because only some of its prerequisites are complete. Therefore, D is completed next.
    F is the only choice, so it is done next.
    Finally, E is completed.

So, in this example, the correct order is CABDFE.

In what order should the steps in your instructions be completed?
    
*/
DEFINE VARIABLE cLine  AS CHARACTER   EXTENT 10 NO-UNDO.
DEFINE VARIABLE cSteps AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSteps AS INTEGER     NO-UNDO.
DEFINE VARIABLE lStep  AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttStep NO-UNDO
 FIELD id    AS CHARACTER  
 FIELD lDone     AS LOGICAL    
 INDEX ix IS PRIMARY UNIQUE id.

DEFINE TEMP-TABLE ttOrder NO-UNDO
 FIELD cStepFrom AS CHARACTER  
 FIELD cStepTo   AS CHARACTER  
 FIELD lReady    AS LOGICAL    
 INDEX ix IS PRIMARY UNIQUE cStepFrom cStepTo.
 .

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

/* then process ready links */
blk:
DO WHILE iSteps >= 0:
    FOR EACH ttOrder WHERE ttOrder.lReady = YES
       ,FIRST ttStep WHERE ttStep.id = ttOrder.cStepTo AND ttStep.lDone = NO
        BY ttOrder.cStepTo:

        IF CAN-FIND(FIRST bttOrder WHERE bttOrder.cStepTo = ttOrder.cStepTo AND bttOrder.lReady = NO) THEN
            NEXT.
        ASSIGN
            cSteps = cSteps + ttOrder.cStepTo
            iSteps = iSteps - 1
            ttStep.lDone = YES.
        IF iSteps = 0 THEN LEAVE blk.
        FOR EACH bttOrder WHERE bttOrder.cStepFrom = ttOrder.cStepTo:
            bttOrder.lReady = YES.
        END.
        LEAVE.
    END.
END.

MESSAGE ETIME SKIP
    cSteps
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 60 */
/* LAPFCRGHVZOTKWENBXIMSUDJQY */
