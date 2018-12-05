/*
--- Day 5: Alchemical Reduction ---

You've managed to sneak in to the prototype suit manufacturing lab. The Elves are making decent progress, but are still struggling with the suit's size reduction capabilities.

While the very latest in 1518 alchemical technology might have solved their problem eventually, you can do better. You scan the chemical composition of the suit's material and discover that it is formed by extremely long polymers (one of which is available as your puzzle input).

The polymer is formed by smaller units which, when triggered, react with each other such that two adjacent units of the same type and opposite polarity are destroyed. Units' types are represented by letters; units' polarity is represented by capitalization. For instance, r and R are units with the same type but opposite polarity, whereas r and s are entirely different types and do not react.

For example:

    In aA, a and A react, leaving nothing behind.
    In abBA, bB destroys itself, leaving aA. As above, this then destroys itself, leaving nothing.
    In abAB, no two adjacent units are of the same type, and so nothing happens.
    In aabAAB, even though aa and AA are of the same type, their polarities match, and so nothing happens.

Now, consider a larger example, dabAcCaCBAcCcaDA:

dabAcCaCBAcCcaDA  The first 'cC' is removed.
dabAaCBAcCcaDA    This creates 'Aa', which is removed.
dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
dabCBAcaDA        No further actions can be taken.

After all possible reactions, the resulting polymer contains 10 units.

How many units remain after fully reacting the polymer you scanned? (Note: in this puzzle and others, the input is large; if you copy/paste your input, make sure you get the whole thing.)

*/
DEFINE VARIABLE c             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLength       AS INTEGER     INITIAL ? NO-UNDO.
DEFINE VARIABLE lcPolymer     AS LONGCHAR    NO-UNDO.

FUNCTION react RETURNS LOGICAL:
    DEFINE VARIABLE c1     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c2     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lReact AS LOGICAL     NO-UNDO.

    DO i = LENGTH(lcPolymer) - 1 TO 1 BY -1:
        ASSIGN
            c1 = SUBSTRING(lcPolymer, i, 1)
            c2 = SUBSTRING(lcPolymer, i + 1, 1).
        IF ABSOLUTE(ASC(c1) - ASC(c2)) = 32 THEN DO:
            SUBSTRING(lcPolymer,i,2) = "".
            lReact = YES.
            i = i - 1.
        END.
    END.

    RETURN lReact.
END FUNCTION.

ETIME(YES).

COPY-LOB FILE "C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day5.txt" TO lcPolymer.

DO WHILE react():
END.

MESSAGE ETIME SKIP
    LENGTH(lcPolymer)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 42580 */
/* 10804 */

