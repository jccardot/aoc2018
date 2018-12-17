/*
--- Day 16: Chronal ClassifiCation ---

--- Part Two ---

Using the samples you collected, work out the number of each opcode and execute the test program (the second section of your puzzle input).

What value is contained in register 0 after executing the test program?

*/
&GLOBAL-DEFINE xiNbOpCodes 16
DEFINE VARIABLE cAfter     AS CHARACTER   EXTENT 5 NO-UNDO.
DEFINE VARIABLE cBefore    AS CHARACTER   EXTENT 5 NO-UNDO.
DEFINE VARIABLE cLine      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOpCode    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOperation AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOps       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iA         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iB         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iC         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOpCode    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOperation AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegAfter  AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegBefore AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegister  AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE lInProgram AS LOGICAL     NO-UNDO.

FUNCTION bin_and RETURNS INTEGER
    (iFirstOperand AS INTEGER, iSecondOperand AS INTEGER):
    DEFINE VARIABLE iLoopCounter AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iANDedResult AS INTEGER   NO-UNDO.

    DO iLoopCounter = 1 to 32:
      IF GET-BITS(iFirstOperand, iLoopCounter, 1) + GET-BITS(iSecondOperand, iLoopCounter, 1) EQ 2 THEN
        iANDedResult = iANDedResult + EXP(2, iLoopCounter - 1).
    END.
    RETURN iANDedResult.
END FUNCTION.

FUNCTION bin_or RETURNS INTEGER
    (iFirstOperand AS INTEGER, iSecondOperand AS INTEGER):
    DEFINE VARIABLE iLoopCounter AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iORedResult  AS INTEGER   NO-UNDO.

    DO iLoopCounter = 1 to 32:
      IF GET-BITS(iFirstOperand, iLoopCounter, 1) + GET-BITS(iSecondOperand, iLoopCounter, 1) GE 1 THEN
        iORedResult = iORedResult + EXP(2, iLoopCounter - 1).
    END.
    RETURN iORedResult.
END FUNCTION.

DEFINE TEMP-TABLE ttOp NO-UNDO
 FIELD iOpCode AS INTEGER
 FIELD cOperation AS CHARACTER INITIAL ",addr,addi,mulr,muli,banr,bani,borr,bori,setr,seti,gtir,gtri,gtrr,eqir,eqri,eqrr"
 INDEX ix IS PRIMARY UNIQUE iOpCode
 INDEX io cOperation.
DEFINE BUFFER bttOp FOR ttOp.

/*****************************************************************************/

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day16.txt.
REPEAT:
    ASSIGN
        cBefore    = ""
        cAfter     = ""
        iOperation = ?.
    IMPORT DELIMITER " " cBefore.
    IF cBefore[1] = "" THEN DO: /* Program part of the input */
        /* First, clean-up the operations */
        DEFINE VARIABLE lFlag AS LOGICAL     NO-UNDO.
        blkClean:
        DO WHILE TRUE:
            lFlag = NO.
            FOR EACH ttOp WHERE NUM-ENTRIES(ttOp.cOperation) = 2:
                cOperation = ENTRY(2, ttOp.cOperation).
                REPEAT PRESELECT EACH bttOp WHERE bttOp.iOpCode <> ttOp.iOpCode AND LOOKUP(cOperation, bttOp.cOperation) > 0:
                    FIND NEXT bttOp.
                    lFlag = YES.
                    bttOp.cOperation = REPLACE(bttOp.cOperation, "," + cOperation, "").
                END.
            END.
            IF NOT lFlag THEN LEAVE blkClean.
        END.
        FOR EACH ttOp:
            ttOp.cOperation = SUBSTRING(ttOp.cOperation, 2).
        END.

        /* Run the program */
        iRegister = 0.
        blkProgram:
        REPEAT:
            iOperation = ?.
            IMPORT DELIMITER " " iOperation.
            ASSIGN
                iOpCode = iOperation[1]
                iA      = iOperation[2]
                iB      = iOperation[3]
                iC      = iOperation[4].
            IF iOpCode = ? THEN NEXT blkProgram.
            FIND ttOp WHERE ttOp.iOpCode = iOpCode.
            cOperation = ttOp.cOperation.
            RUN doOperation.
        END.
        LEAVE.
    END.
    ASSIGN
        iRegBefore[1] = INTEGER(TRIM(cBefore[2], "[,"))
        iRegBefore[2] = INTEGER(TRIM(cBefore[3], "," ))
        iRegBefore[3] = INTEGER(TRIM(cBefore[4], "," ))
        iRegBefore[4] = INTEGER(TRIM(cBefore[5], ",]")).
    IMPORT DELIMITER " " iOperation.
    ASSIGN
        iOpCode = iOperation[1]
        iA      = iOperation[2]
        iB      = iOperation[3]
        iC      = iOperation[4].
    IMPORT DELIMITER " " cAfter.
    ASSIGN
        iRegAfter[1] = INTEGER(TRIM(cAfter[2], "[,"))
        iRegAfter[2] = INTEGER(TRIM(cAfter[3], "," ))
        iRegAfter[3] = INTEGER(TRIM(cAfter[4], "," ))
        iRegAfter[4] = INTEGER(TRIM(cAfter[5], ",]")).
    IMPORT cLine.

    FIND ttOp WHERE ttOp.iOpCode = iOpCode NO-ERROR.
    IF NOT AVAILABLE ttOp THEN DO:
        CREATE ttOp.
        ASSIGN ttOp.iOpCode = iOpCode.
    END.

    DO i = NUM-ENTRIES(ttOp.cOperation) TO 2 BY -1:
        cOperation = ENTRY(i, ttOp.cOperation).

        iRegister = iRegBefore.

        RUN doOperation.

        IF   iRegister[1] <> iRegAfter[1]
          OR iRegister[2] <> iRegAfter[2]
          OR iRegister[3] <> iRegAfter[3]
          OR iRegister[4] <> iRegAfter[4] THEN DO:
            ttOp.cOperation = REPLACE(ttOp.cOperation, "," + cOperation, "").
        END.
    END.
END.
INPUT CLOSE.

/* FOR EACH ttOp: */
    /* DISP ttOp.iOpCode ttOp.cOperation FORMAT "X(30)". */
/* END. */

MESSAGE ETIME SKIP
    iRegister[1]
    iRegister[2]
    iRegister[3]
    iRegister[4]
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 314 */
/* 622 0 622 1 */
    
PROCEDURE doOperation:
    CASE cOperation:
        WHEN "addr" THEN    
            iRegister[iC + 1] = iRegister[iA + 1] + iRegister[iB + 1].
        WHEN "addi" THEN    
            iRegister[iC + 1] = iRegister[iA + 1] + iB.
        WHEN "mulr" THEN    
            iRegister[iC + 1] = iRegister[iA + 1] * iRegister[iB + 1].
        WHEN "muli" THEN    
            iRegister[iC + 1] = iRegister[iA + 1] * iB.
        WHEN "banr" THEN    
            iRegister[iC + 1] = bin_and(iRegister[iA + 1], iRegister[iB + 1]).
        WHEN "bani" THEN    
            iRegister[iC + 1] = bin_and(iRegister[iA + 1], iB).
        WHEN "borr" THEN    
            iRegister[iC + 1] = bin_or(iRegister[iA + 1], iRegister[iB + 1]).
        WHEN "bori" THEN    
            iRegister[iC + 1] = bin_or(iRegister[iA + 1], iB).
        WHEN "setr" THEN    
            iRegister[iC + 1] = iRegister[iA + 1].
        WHEN "seti" THEN    
            iRegister[iC + 1] = iA.
        WHEN "gtir" THEN    
            iRegister[iC + 1] = IF iA > iRegister[iB + 1] THEN 1 ELSE 0.
        WHEN "gtri" THEN    
            iRegister[iC + 1] = IF iRegister[iA + 1] > iB THEN 1 ELSE 0.
        WHEN "gtrr" THEN    
            iRegister[iC + 1] = IF iRegister[iA + 1] > iRegister[iB + 1] THEN 1 ELSE 0.
        WHEN "eqir" THEN    
            iRegister[iC + 1] = IF iA = iRegister[iB + 1] THEN 1 ELSE 0.
        WHEN "eqri" THEN    
            iRegister[iC + 1] = IF iRegister[iA + 1] = iB THEN 1 ELSE 0.
        WHEN "eqrr" THEN    
            iRegister[iC + 1] = IF iRegister[iA + 1] = iRegister[iB + 1] THEN 1 ELSE 0.
        OTHERWISE MESSAGE "unknown operation " cOperation
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END CASE.
END PROCEDURE.

