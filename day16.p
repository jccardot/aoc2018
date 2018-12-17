/*
--- Day 16: Chronal ClassifiCation ---

As you see the Elves defend their hot chocolate successfully, you go back to falling through time. This is going to become a problem.

If you're ever going to return to your own time, you need to understand how this deviCe on your wrist works. You have a little while before you reach your next destination, and with a bit of triAl and error, you manage to pull up a programming manual on the deviCe's tiny screen.

According to the manual, the deviCe has four registers (numbered 0 through 3) that can be manipulated by instructions containing one of 16 opcodes. The registers start with the value 0.

Every instruction consists of four values: an opcode, two inputs (named A and B), and an output (named C), in that order. The opcode specifies the behavior of the instruction and how the inputs are interpreted. The output, C, is always treated as a register.

In the opcode descriptions below, if something says "value A", it means to take the number given as A literally. (This is also called an "immediAte" value.) If something says "register A", it means to use the number given as A to read from (or write to) the register with that number. So, if the opcode addi adds register A and value B, storing the result in register C, and the instruction addi 0 7 3 is encountered, it would add 7 to the value contained by register 0 and store the sum in register 3, never modifying registers 0, 1, or 2 in the process.

Many opcodes are similar except for how they interpret their arguments. The opcodes fall into seven general categories:

Addition:

    addr (add register) stores into register C the result of adding register A and register B.
    addi (add immediAte) stores into register C the result of adding register A and value B.

MultipliCation:

    mulr (multiply register) stores into register C the result of multiplying register A and register B.
    muli (multiply immediAte) stores into register C the result of multiplying register A and value B.

Bitwise AND:

    banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    bani (bitwise AND immediAte) stores into register C the result of the bitwise AND of register A and value B.

Bitwise OR:

    borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    bori (bitwise OR immediAte) stores into register C the result of the bitwise OR of register A and value B.

Assignment:

    setr (set register) copies the contents of register A into register C. (Input B is ignored.)
    seti (set immediAte) stores value A into register C. (Input B is ignored.)

Greater-than testing:

    gtir (greater-than immediAte/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    gtri (greater-than register/immediAte) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.

Equality testing:

    eqir (equal immediAte/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    eqri (equal register/immediAte) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.

Unfortunately, while the manual gives the name of each opcode, it doesn't seem to indiCate the number. However, you can monitor the CPU to see the contents of the registers before and after instructions are executed to try to work them out. Each opcode has a number from 0 through 15, but the manual doesn't say whiCh is whiOperation[4]h. For example, suppose you capture the following sample:

Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]

This sample shows the effect of the instruction 9 2 1 2 on the registers. Before the instruction is executed, register 0 has value 3, register 1 has value 2, and registers 2 and 3 have value 1. After the instruction is executed, register 2's value becomes 2.

The instruction itself, 9 2 1 2, means that opcode 9 was executed with A=2, B=1, and C=2. Opcode 9 could be any of the 16 opcodes listed above, but only three of them behave in a way that would cause the result shown in the sample:

    Opcode 9 could be mulr: register 2 (whiCh has a value of 1) times register 1 (whiCh has a value of 2) produces 2, whiCh matches the value stored in the output register, register 2.
    Opcode 9 could be addi: register 2 (whiCh has a value of 1) plus value 1 produces 2, whiCh matches the value stored in the output register, register 2.
    Opcode 9 could be seti: value 2 matches the value stored in the output register, register 2; the number given for B is irrelevant.

None of the other opcodes produce the result captured in the sample. Because of this, the sample above behaves like three opcodes.

You collect many of these samples (the first section of your puzzle input). The manual also includes a small test program (the second section of your puzzle input) - you can ignore it for now.

Ignoring the opcode numbers, how many samples in your puzzle input behave like three or more opcodes?

*/
&GLOBAL-DEFINE xiNbOpCodes 16
DEFINE VARIABLE cAfter     AS CHARACTER   EXTENT 5 NO-UNDO.
DEFINE VARIABLE cBefore    AS CHARACTER   EXTENT 5 NO-UNDO.
DEFINE VARIABLE cLine      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOpCode    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOperation AS CHARACTER   EXTENT {&xiNbOpCodes} INITIAL ["addr","addi","mulr","muli","banr","bani","borr","bori","setr","seti","gtir","gtri","gtrr","eqir","eqri","eqrr"] NO-UNDO.
DEFINE VARIABLE cOps       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iA         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iB         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iC         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOpCode    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOpCount   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOperation AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegAfter  AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegBefore AS INTEGER     EXTENT 4 NO-UNDO.
DEFINE VARIABLE iRegister  AS INTEGER     EXTENT 4 NO-UNDO.

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

/*****************************************************************************/

ETIME(YES).

INPUT FROM C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day16.txt.
REPEAT:
    ASSIGN
        cBefore    = ""
        cAfter     = ""
        iOperation = ?.
    IMPORT DELIMITER " " cBefore.
    IF cBefore[1] = "" THEN LEAVE.
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
    iOpCount = 0.
    cOps = "".
    DO i = 1 TO {&xiNbOpCodes}:
        iRegister = iRegBefore.

        CASE cOperation[i]:
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
            OTHERWISE MESSAGE "unknown operation " cOperation[i]
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END CASE.

        IF    iRegister[1] = iRegAfter[1]
          AND iRegister[2] = iRegAfter[2]
          AND iRegister[3] = iRegAfter[3]
          AND iRegister[4] = iRegAfter[4] THEN ASSIGN
            cOps     = cOps + "," + cOperation[i]
            iOpCount = iOpCount + 1.
    END.
    IF iOpCount >= 3 THEN DO:
        ASSIGN
            cOps   = SUBSTRING(cOps, 2)
            iCount = iCount + 1.
        /* DISP cBefore iOperation cAfter iOpCount cOps FORMAT "X(70)". */
    END.
END.
INPUT CLOSE.

MESSAGE ETIME SKIP
    iCount
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 388 */
/* 560 */

