/*
--- Day 19: Go With The Flow ---

--- Part Two ---

A new background process immediately spins up in its place. It appears identical, but on closer inspection, you notice that this time, register 0 started with the value 1.

What value is left in register 0 when this new background process halts?

*/

DEFINE VARIABLE a      AS INTEGER   NO-UNDO.
DEFINE VARIABLE b      AS INTEGER   NO-UNDO.
DEFINE VARIABLE c      AS INTEGER   NO-UNDO.
DEFINE VARIABLE e      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER   NO-UNDO.

ETIME(YES).

ASSIGN
    a = 0
    b = 1
    e = 10550400 /* ( 27 * 28 + 29 ) * 30 * 14 * 32 */
    c = 10551282 /* i1 + (2 * 2 * 19 * 11) + (2 * 22 + 2) */
    .

DO WHILE TRUE:
    iCount = iCount + 1.
    IF c MODULO b = 0 THEN
        a = a + b.
    b = b + 1.
    IF b > c THEN
        LEAVE.
    IF iCount MODULO 10000 = 0 THEN DISP a b c ETIME.
END.

MESSAGE ETIME SKIP
    a
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 18538 */
/* 24117312 */

