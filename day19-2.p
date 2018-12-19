/*
--- Day 19: Go With The Flow ---

--- Part Two ---

A new background process immediately spins up in its place. It appears identical, but on closer inspection, you notice that this time, register 0 started with the value 1.

What value is left in register 0 when this new background process halts?

*/
DEFINE VARIABLE iOperations AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPC         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPCReg      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iProgSeq    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRegister   AS INTEGER   EXTENT 6 NO-UNDO.

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

DEFINE TEMP-TABLE ttProgram NO-UNDO
    FIELD id AS INTEGER
    FIELD cOperation AS CHAR
    FIELD iA AS INTEGER
    FIELD iB AS INTEGER
    FIELD iC AS INTEGER
    INDEX ix IS PRIMARY UNIQUE id.

/*****************************************************************************/

ETIME(YES).

/* load the program */
INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day19.txt.
REPEAT:
    CREATE ttProgram.
    ASSIGN ttProgram.id = iProgSeq.
    IMPORT DELIMITER " " ttProgram.cOperation ttProgram.iA ttProgram.iB ttProgram.iC.
    IF ttProgram.cOperation = "#ip" THEN DO:
        iPCReg = ttProgram.iA + 1.
        DELETE ttProgram.
    END.
    ELSE
        iProgSeq = iProgSeq + 1.
END.
DELETE ttProgram.
INPUT CLOSE.

/* FOR EACH ttProgram: DISP ttProgram. END. */

iRegister[1] = 1.

/* run it */
DO WHILE TRUE:
    FIND ttProgram WHERE ttProgram.id = iPC NO-ERROR.
    IF NOT AVAILABLE ttProgram THEN LEAVE.
    iRegister[iPCReg] = iPC.
    RUN doOperation.
    iPC = iRegister[iPCReg] + 1.
    /* MESSAGE iPC SKIP iRegister[1] iRegister[2] iRegister[3] iRegister[4] iRegister[5] iRegister[6] */
        /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    iOperations = iOperations + 1.
    IF iOperations MOD 10000 = 0 THEN DISP iOperations / 10000 FORMAT "999999999999" ETIME SKIP iPC SKIP iRegister[1] iRegister[2] iRegister[3] iRegister[4] iRegister[5] iRegister[6].
END.

MESSAGE ETIME SKIP
    iRegister[1]
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 113022 */
/* 2223 */
    
PROCEDURE doOperation:
    CASE ttProgram.cOperation:
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
        OTHERWISE MESSAGE "unknown operation " ttProgram.cOperation
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END CASE.
END PROCEDURE.

