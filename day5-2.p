/*
--- Day 5: Alchemical Reduction ---

--- Part Two ---

Time to improve the polymer.

One of the unit types is causing problems; it's preventing the polymer from collapsing as much as it should. Your goal is to figure out which unit type is causing the most problems, remove all instances of it (regardless of polarity), fully react the remaining polymer, and measure its length.

For example, again using the polymer dabAcCaCBAcCcaDA from above:

    Removing all A/a units produces dbcCCBcCcD. Fully reacting this polymer produces dbCBcD, which has length 6.
    Removing all B/b units produces daAcCaCAcCcaDA. Fully reacting this polymer produces daCAcaDA, which has length 8.
    Removing all C/c units produces dabAaBAaDA. Fully reacting this polymer produces daDA, which has length 4.
    Removing all D/d units produces abAcCaCBAcCcaA. Fully reacting this polymer produces abCBAc, which has length 6.

In this example, removing all C/c units was best, producing the answer 4.

What is the length of the shortest polymer you can produce by removing all units of exactly one type and fully reacting the result?

*/
DEFINE VARIABLE c             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLength       AS INTEGER     INITIAL ? NO-UNDO.
DEFINE VARIABLE lcPolymer     AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE lcPolymerTest AS LONGCHAR    NO-UNDO.

DEFINE TEMP-TABLE ttUnit NO-UNDO LABEL ""
 FIELD c AS CHARACTER
 INDEX ix IS PRIMARY UNIQUE c.

FUNCTION react RETURNS LOGICAL:
    DEFINE VARIABLE c1     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c2     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lReact AS LOGICAL     NO-UNDO.

    DO i = LENGTH(lcPolymerTest) - 1 TO 1 BY -1:
        ASSIGN
            c1 = SUBSTRING(lcPolymerTest, i, 1)
            c2 = SUBSTRING(lcPolymerTest, i + 1, 1).
        IF ABSOLUTE(ASC(c1) - ASC(c2)) = 32 THEN DO:
            SUBSTRING(lcPolymerTest,i,2) = "".
            lReact = YES.
            i = i - 1.
        END.
    END.

    RETURN lReact.
END FUNCTION.

ETIME(YES).

COPY-LOB FILE "C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day5.txt" TO lcPolymer.

DO i = LENGTH(lcPolymer) TO 1 BY -1:
    c = SUBSTRING(lcPolymer, i, 1).
    IF NOT CAN-FIND(ttUnit WHERE ttUnit.c = c) THEN DO:
        CREATE ttUnit.
        ASSIGN ttUnit.c = c.
    END.
END.

FOR EACH ttUnit:
    lcPolymerTest = REPLACE(lcPolymer, ttUnit.c, "").
    DO WHILE react():
    END.
    iLength = IF iLength = ? THEN LENGTH(lcPolymerTest) ELSE MINIMUM(iLength, LENGTH(lcPolymerTest)).
END.

MESSAGE ETIME SKIP
    iLength
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 1285093 */
/* 6650 */
    
