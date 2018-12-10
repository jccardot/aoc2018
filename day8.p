/*
--- Day 8: Memory Maneuver ---

The sleigh is much easier to pull than you'd expect for something its weight. Unfortunately, neither you nor the Elves know which way the North Pole is from here.

You check your wrist device for anything that might help. It seems to have some kind of navigation system! Activating the navigation system produces more bad news: "Failed to start navigation system. Could not read software license file."

The navigation system's license file consists of a list of numbers (your puzzle input). The numbers define a data structure which, when processed, produces some kind of tree that can be used to calculate the license number.

The tree is made up of nodes; a single, outermost node forms the tree's root, and it contains all other nodes in the tree (or contains nodes that contain nodes, and so on).

Specifically, a node consists of:

    A header, which is always exactly two numbers:
        The quantity of child nodes.
        The quantity of metadata entries.
    Zero or more child nodes (as specified in the header).
    One or more metadata entries (as specified in the header).

Each child node is itself a node that has its own header, child nodes, and metadata. For example:

2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
A----------------------------------
    B----------- C-----------
                     D-----

In this example, each node of the tree is also marked with an underline starting with a letter for easier identification. In it, there are four nodes:

    A, which has 2 child nodes (B, C) and 3 metadata entries (1, 1, 2).
    B, which has 0 child nodes and 3 metadata entries (10, 11, 12).
    C, which has 1 child node (D) and 1 metadata entry (2).
    D, which has 0 child nodes and 1 metadata entry (99).

The first check done on the license file is to simply add up all of the metadata entries. In this example, that sum is 1+1+2+10+11+12+2+99=138.

What is the sum of all metadata entries?
    
*/
DEFINE VARIABLE iData    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos     AS INTEGER    INITIAL 1 NO-UNDO.
DEFINE VARIABLE lcData   AS LONGCHAR   NO-UNDO.

ETIME(YES).

COPY-LOB FILE "C:\User\JCCARDOT\Perso\Travail\aoc\aoc2018\day8.txt" TO lcData.

lcData = REPLACE(REPLACE(lcData, CHR(10), ""), CHR(13), "").

FUNCTION getMetaSum RETURNS INTEGER ( INPUT-OUTPUT piPos AS INTEGER ):
    DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iChilds  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iMetas   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iMetaSum AS INTEGER   NO-UNDO.

    ASSIGN
        iChilds = INTEGER(ENTRY(piPos, lcData, " "))
        iMetas  = INTEGER(ENTRY(piPos + 1, lcData, " "))
        piPos   = piPos + 2.

    IF iChilds > 0 THEN DO i = 1 TO iChilds:
        iMetaSum = iMetaSum + getMetaSum(INPUT-OUTPUT piPos).
    END.

    IF iMetas > 0 THEN DO:
        DO i = 0 TO iMetas - 1:
            iMetaSum = iMetaSum + INTEGER(ENTRY(piPos + i, lcData, " ")).
        END.
        piPos = piPos + iMetas.
    END.

    RETURN iMetaSum.
END FUNCTION.

MESSAGE ETIME SKIP
    getMetaSum(INPUT-OUTPUT iPos)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 2 */
/* 48496 */
