# PegSolitaire

[Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire) solver in OCaml

![Screenshot](https://github.com/James-P-D/PegSolitaire/blob/master/screenshot.gif)

## Details

Peg-Solitaire is a one-player game in which a number of marbles are placed on a grid with one empty location in the centre. The objective of the game is to remove marbles from the grid by jumping over them into empty locations, eventually resulting in a board which contains only one marble in the centre cell. Note that marbles can only jump horizontally and vertically and not diagonally, and that they can only jump over pieces that are immediate neighbours.

For example, given the initial [English Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire#Board) board:

```
   0  1  2  3  4  5  6 
0        O  O  O       
1        O  O  O       
2  O  O  O  O  O  O  O 
3  O  O  O  -  O  O  O 
4  O  O  O  O  O  O  O 
5        O  O  O       
6        O  O  O       
```

The player could choose to move the marble at `(3, 1)` to `(3, 3)`, which would cause the removal of the marble at `(3, 2)`:

```
   0  1  2  3  4  5  6 
0        O  O  O       
1        O  -  O       
2  O  O  O  -  O  O  O 
3  O  O  O  O  O  O  O 
4  O  O  O  O  O  O  O 
5        O  O  O       
6        O  O  O       
```

Then the player could move `(5, 2)` to `(3, 2)` which would remove `(4, 2)`:

```
   0  1  2  3  4  5  6 
0        O  O  O       
1        O  -  O       
2  O  O  O  O  -  -  O 
3  O  O  O  O  O  O  O 
4  O  O  O  O  O  O  O 
5        O  O  O       
6        O  O  O       
```

If we make a series of bad decisions, we might find ourselves with a board like this:

```
    0  1  2  3  4  5  6 
0         O  O  O
1         O  -  O
2   O  O  O  O  O  O  O
3   O  -  O  -  O  -  -
4   O  O  O  O  O  O  O
5         O  -  O
6         O  -  O
```

At this point we are stuck because there are no more valid moves we can make. This is a terminal state.

However, if we choose wisely, we'll end up with a board with a single marble at `(3, 3)`, which is the completed state:

```
    0  1  2  3  4  5  6 
0         -  -  -
1         -  -  -
2   -  -  -  -  -  -  -
3   -  -  -  O  -  -  -
4   -  -  -  -  -  -  -
5         -  -  -
6         -  -  -
```

For much more information on the puzzle see [Durango Bill's website](http://www.durangobill.com/Peg33.html#:~:text=The%204%20possible%20legal%20moves,center%20hole%2C%20the%20player%20wins.)

## Algorithm

The OCaml program performs a [depth-first search](https://en.wikipedia.org/wiki/Depth-first_search) recursively on the board. If it encounters a terminal state (i.e. a board where there are no more possible moves) it will backtrack through previous states until it encounters a move it hasn't yet made. This process is repeated until we reach the complete state (i.e. a board with only one marble left at cell `(3, 3)`), at which point it will unwind and produce a list of moves which will take us from the start to the completed board. If the program is unable to reach the complete state it will return an empty list.

This list returned will be comprised of tuples in the form `(x1, y1, x2, y2)` where `(x1, y1)` is the position of a marble and `(x2, y2)` is the position of an empty cell. We can then run this list through the `apply_move_list` function to step-through each state from beginning to end.

## Running

The application has been tested with [OCaml v4.10.0](https://ocaml.org/docs/install.html). Simply run the `OCaml64` shortcut, change to the folder containing [solitaire.ml](https://github.com/James-P-D/PegSolitaire/blob/master/src/solitaire.ml) and then use `ocamlopt` to compile to native code:

```
jdorr@DESKTOP-MF9T345 /cygdrive/c/Users/jdorr/Desktop/Dev/PegSolitaire/src
$ ocamlopt -o solitaire solitaire.ml
```

You can then run the `./solitaire.exe` executable:

```
jdorr@DESKTOP-MF9T345 /cygdrive/c/Users/jdorr/Desktop/Dev/PegSolitaire/src
$ ./solitaire.exe
   0  1  2  3  4  5  6
0        O  O  O
1        O  O  O
2  O  O  O  O  O  O  O
3  O  O  O  -  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O
```

There will be a long pause whilst our program searches for a solution to the puzzle. After ~20 seconds you should see the following:

```
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  O  -  -  -
4  -  -  -  -  -  -  -
5        -  -  -
6        -  -  -

Success!
Press ENTER to step through moves to complete puzzle
```

Our program has found a solution which can now be stepped-through by pressing <kbd>enter</kbd>:

```
   0  1  2  3  4  5  6
0        O  O  O
1        O  O  O
2  O  O  O  O  O  O  O
3  O  O  O  -  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(3, 1) -> (3, 3)
   0  1  2  3  4  5  6
0        O  O  O
1        O  -  O
2  O  O  O  -  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(1, 2) -> (3, 2)
   0  1  2  3  4  5  6
0        O  O  O
1        O  -  O
2  O  -  -  O  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(2, 0) -> (2, 2)
   0  1  2  3  4  5  6
0        -  O  O
1        -  -  O
2  O  -  O  O  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(4, 0) -> (2, 0)
   0  1  2  3  4  5  6
0        O  -  -
1        -  -  O
2  O  -  O  O  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(3, 2) -> (1, 2)
   0  1  2  3  4  5  6
0        O  -  -
1        -  -  O
2  O  O  -  -  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(0, 2) -> (2, 2)
   0  1  2  3  4  5  6
0        O  -  -
1        -  -  O
2  -  -  O  -  O  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(4, 2) -> (4, 0)
   0  1  2  3  4  5  6
0        O  -  O
1        -  -  -
2  -  -  O  -  -  O  O
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(6, 2) -> (4, 2)
   0  1  2  3  4  5  6
0        O  -  O
1        -  -  -
2  -  -  O  -  O  -  -
3  O  O  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(2, 3) -> (2, 1)
   0  1  2  3  4  5  6
0        O  -  O
1        O  -  -
2  -  -  -  -  O  -  -
3  O  O  -  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(2, 0) -> (2, 2)
   0  1  2  3  4  5  6
0        -  -  O
1        -  -  -
2  -  -  O  -  O  -  -
3  O  O  -  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(0, 3) -> (2, 3)
   0  1  2  3  4  5  6
0        -  -  O
1        -  -  -
2  -  -  O  -  O  -  -
3  -  -  O  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(2, 3) -> (2, 1)
   0  1  2  3  4  5  6
0        -  -  O
1        O  -  -
2  -  -  -  -  O  -  -
3  -  -  -  O  O  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(4, 3) -> (4, 1)
   0  1  2  3  4  5  6
0        -  -  O
1        O  -  O
2  -  -  -  -  -  -  -
3  -  -  -  O  -  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(4, 0) -> (4, 2)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  -
2  -  -  -  -  O  -  -
3  -  -  -  O  -  O  O
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(6, 3) -> (4, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  -
2  -  -  -  -  O  -  -
3  -  -  -  O  O  -  -
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(4, 3) -> (4, 1)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  O
2  -  -  -  -  -  -  -
3  -  -  -  O  -  -  -
4  O  O  O  O  O  O  O
5        O  O  O
6        O  O  O

(2, 5) -> (2, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  O
2  -  -  -  -  -  -  -
3  -  -  O  O  -  -  -
4  O  O  -  O  O  O  O
5        -  O  O
6        O  O  O

(0, 4) -> (2, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  O
2  -  -  -  -  -  -  -
3  -  -  O  O  -  -  -
4  -  -  O  O  O  O  O
5        -  O  O
6        O  O  O

(2, 4) -> (2, 2)
   0  1  2  3  4  5  6
0        -  -  -
1        O  -  O
2  -  -  O  -  -  -  -
3  -  -  -  O  -  -  -
4  -  -  -  O  O  O  O
5        -  O  O
6        O  O  O

(2, 1) -> (2, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  O
2  -  -  -  -  -  -  -
3  -  -  O  O  -  -  -
4  -  -  -  O  O  O  O
5        -  O  O
6        O  O  O

(2, 3) -> (4, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  O
2  -  -  -  -  -  -  -
3  -  -  -  -  O  -  -
4  -  -  -  O  O  O  O
5        -  O  O
6        O  O  O

(4, 4) -> (4, 2)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  O
2  -  -  -  -  O  -  -
3  -  -  -  -  -  -  -
4  -  -  -  O  -  O  O
5        -  O  O
6        O  O  O

(4, 1) -> (4, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  O  -  -
4  -  -  -  O  -  O  O
5        -  O  O
6        O  O  O

(6, 4) -> (4, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  O  -  -
4  -  -  -  O  O  -  -
5        -  O  O
6        O  O  O

(3, 4) -> (5, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  O  -  -
4  -  -  -  -  -  O  -
5        -  O  O
6        O  O  O

(4, 6) -> (4, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  O  -  -
4  -  -  -  -  O  O  -
5        -  O  -
6        O  O  -

(4, 3) -> (4, 5)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  -  -  -
4  -  -  -  -  -  O  -
5        -  O  O
6        O  O  -

(2, 6) -> (4, 6)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  -  -  -
4  -  -  -  -  -  O  -
5        -  O  O
6        -  -  O

(4, 6) -> (4, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  -  -  -
4  -  -  -  -  O  O  -
5        -  O  -
6        -  -  -

(5, 4) -> (3, 4)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  -  -  -  -
4  -  -  -  O  -  -  -
5        -  O  -
6        -  -  -

(3, 5) -> (3, 3)
   0  1  2  3  4  5  6
0        -  -  -
1        -  -  -
2  -  -  -  -  -  -  -
3  -  -  -  O  -  -  -
4  -  -  -  -  -  -  -
5        -  -  -
6        -  -  -

jdorr@DESKTOP-MF9T345 /cygdrive/c/Users/jdorr/Desktop/Dev/PegSolitaire/src
$
```

Finally, you can also try running the program on the [Try OCAML](https://try.ocamlpro.com/) website. It will be *very* slow (2m40s on my machine), and you'll need to comment-out any `input_line stdin` statements as the site does not appear to support user input. The site will also think that the application is stuck in an infinite loop and attempt to timeout. Simply hit the <kbd>10 seconds!</kbd> button to bump-up the timeout:

![Screenshot](https://github.com/James-P-D/PegSolitaire/blob/master/tryocamlwebsite.gif)