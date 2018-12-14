/*
--- Day 14: Chocolate Charts ---

You finally have a chance to look at all of the produce moving around. Chocolate, cinnamon, mint, chili peppers, nutmeg, vanilla... the Elves must be growing these plants to make hot chocolate! As you realize this, you hear a conversation in the distance. When you go to investigate, you discover two Elves in what appears to be a makeshift underground kitchen/laboratory.

The Elves are trying to come up with the ultimate hot chocolate recipe; they're even maintaining a scoreboard which tracks the quality score (0-9) of each recipe.

Only two recipes are on the board: the first recipe got a score of 3, the second, 7. Each of the two Elves has a current recipe: the first Elf starts with the first recipe, and the second Elf starts with the second recipe.

To create new recipes, the two Elves combine their current recipes. This creates new recipes from the digits of the sum of the current recipes' scores. With the current recipes' scores of 3 and 7, their sum is 10, and so two new recipes would be created: the first with score 1 and the second with score 0. If the current recipes' scores were 2 and 3, the sum, 5, would only create one recipe (with a score of 5) with its single digit.

The new recipes are added to the end of the scoreboard in the order they are created. So, after the first round, the scoreboard is 3, 7, 1, 0.

After all new recipes are added to the scoreboard, each Elf picks a new current recipe. To do this, the Elf steps forward through the scoreboard a number of recipes equal to 1 plus the score of their current recipe. So, after the first round, the first Elf moves forward 1 + 3 = 4 times, while the second Elf moves forward 1 + 7 = 8 times. If they run out of recipes, they loop back around to the beginning. After the first round, both Elves happen to loop around until they land on the same recipe that they had in the beginning; in general, they will move to different recipes.

Drawing the first Elf as parentheses and the second Elf as square brackets, they continue this process:

(3)[7]
(3)[7] 1  0 
 3  7  1 [0](1) 0 
 3  7  1  0 [1] 0 (1)
(3) 7  1  0  1  0 [1] 2 
 3  7  1  0 (1) 0  1  2 [4]
 3  7  1 [0] 1  0 (1) 2  4  5 
 3  7  1  0 [1] 0  1  2 (4) 5  1 
 3 (7) 1  0  1  0 [1] 2  4  5  1  5 
 3  7  1  0  1  0  1  2 [4](5) 1  5  8 
 3 (7) 1  0  1  0  1  2  4  5  1  5  8 [9]
 3  7  1  0  1  0  1 [2] 4 (5) 1  5  8  9  1  6 
 3  7  1  0  1  0  1  2  4  5 [1] 5  8  9  1 (6) 7 
 3  7  1  0 (1) 0  1  2  4  5  1  5 [8] 9  1  6  7  7 
 3  7 [1] 0  1  0 (1) 2  4  5  1  5  8  9  1  6  7  7  9 
 3  7  1  0 [1] 0  1  2 (4) 5  1  5  8  9  1  6  7  7  9  2 

The Elves think their skill will improve after making a few recipes (your puzzle input). However, that could take ages; you can speed this up considerably by identifying the scores of the ten recipes after that. For example:

    If the Elves think their skill will improve after making 9 recipes, the scores of the ten recipes after the first nine on the scoreboard would be 5158916779 (highlighted in the last line of the diagram).
    After 5 recipes, the scores of the next ten would be 0124515891.
    After 18 recipes, the scores of the next ten would be 9251071085.
    After 2018 recipes, the scores of the next ten would be 5941429882.

What are the scores of the ten recipes immediately after the number of recipes in your puzzle input?

Your puzzle input is 793031.
*/

&GLOBAL-DEFINE xiRecipes 793031

DEFINE VARIABLE cRecipes   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iElf1      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iElf1Score AS INTEGER     NO-UNDO.
DEFINE VARIABLE iElf2      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iElf2Score AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRecipeSeq AS INTEGER     NO-UNDO.
DEFINE VARIABLE iScore     AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttRecipe NO-UNDO
 FIELD id AS INTEGER
 FIELD iRecipeScore AS INTEGER
 INDEX ix IS PRIMARY UNIQUE id.
DEFINE BUFFER bttRecipe FOR ttRecipe.

ETIME(YES).

iRecipeSeq = iRecipeSeq + 1.
CREATE ttRecipe.
ASSIGN ttRecipe.id           = iRecipeSeq
       ttRecipe.iRecipeScore = 3.
iElf1 = iRecipeSeq.
iRecipeSeq = iRecipeSeq + 1.
CREATE ttRecipe.
ASSIGN ttRecipe.id           = iRecipeSeq
       ttRecipe.iRecipeScore = 7.
iElf2 = iRecipeSeq.

DO WHILE TRUE:
    FIND ttRecipe WHERE ttRecipe.id = iElf1.
    iElf1Score = ttRecipe.iRecipeScore.
    FIND bttRecipe WHERE bttRecipe.id = iElf2.
    iElf2Score = bttRecipe.iRecipeScore.
    iScore = iElf1Score + iElf2Score.
    /* add the recipe(s) to the list */
    IF iScore > 9 THEN DO:
        iRecipeSeq = iRecipeSeq + 1.
        CREATE bttRecipe.
        ASSIGN bttRecipe.id           = iRecipeSeq
               bttRecipe.iRecipeScore = 1.
        iScore = iScore - 10.
    END.
    FIND ttRecipe WHERE ttRecipe.id = iRecipeSeq. /* last one */
    iRecipeSeq = iRecipeSeq + 1.
    CREATE bttRecipe.
    ASSIGN bttRecipe.id           = iRecipeSeq
           bttRecipe.iRecipeScore = iScore.
    /* end condition */
    IF iRecipeSeq >= {&xiRecipes} + 10 THEN LEAVE.
    /* move the elves */
    iElf1 = iElf1 + 1 + iElf1Score.
    IF iElf1 > iRecipeSeq THEN iElf1 = iElf1 - iRecipeSeq.
    IF iElf1 > iRecipeSeq THEN iElf1 = iElf1 - iRecipeSeq.
    iElf2 = iElf2 + 1 + iElf2Score.
    IF iElf2 > iRecipeSeq THEN iElf2 = iElf2 - iRecipeSeq.
    IF iElf2 > iRecipeSeq THEN iElf2 = iElf2 - iRecipeSeq.
END.

DO i = {&xiRecipes} + 1 TO {&xiRecipes} + 10:
    FIND ttRecipe WHERE ttRecipe.id = i.
    cRecipes = cRecipes + STRING(ttRecipe.iRecipeScore).
END.

MESSAGE ETIME SKIP
    cRecipes
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* 64898 */
/* 4910101614 */

