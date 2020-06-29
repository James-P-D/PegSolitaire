# PegSolitaire

[Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire) solver in OCaml

![Screenshot](https://github.com/James-P-D/PegSolitaire/blob/master/screenshot.gif)

*(Note this screenshot has been edited for brevity. The full process takes several minutes.)*

## Details

Peg-Solitaire is a one-player game whereby a number of marbles are placed on a grid with one empty location. The objective of the game is to remove marbles from the grid by jumping over them into empty locations, eventually resulting in a board which contains only one marble in the centre cell. Note that marbles can only jump horizontally and vertically and not diagonally, and that they can only jump over pieces that are immediate neighbours.

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

If we make bad decisions, we might find ourselves with a board like this:

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

At this point we are stuck because there are no more valid moves we can make.

However, if we choose wisely, we'll end up with a board with a single marble at `(3, 3)`, which is the winning state:

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

The OCaml program simply performs a [depth-first search](https://en.wikipedia.org/wiki/Depth-first_search) recursively on the board. If it encounters a terminal state (I.E. a board where there are no more possible moves) it will backtrack to a previous state until it encounters a move it hasn't yet made. This process is repeated until we reach the complete state (I.E. a board with only one marble left at cell `(3, 3)`, at which point it will unwind and produce a list of moves to get from the initial to the completed board.

This list will be comprised of tuples in the form `(x1, y1, x2, y2)` where `(x1, y1)` is the position of a marble and `(x2, y2)` is the position of an empty cell. We can then run this list through the `apply_move_list` function to step through each state from beginning to end.

## Running

The application has been tested with the [Windows OCaml v 4.10.0](https://ocaml.org/docs/install.html). Simply run the `OCaml64` shortcut and then enter `ocaml` to start the interpreter:

```
jdorr@DESKTOP-MF9T345 ~
$ ocaml
        OCaml version 4.10.0
#
```

Now copy and paste the code from [solitaire.ml](https://github.com/James-P-D/PegSolitaire/blob/master/src/solitaire.ml). You should see something like the following:

```
stuff
```

There will be a long pause whilst our program searches for a solution to the puzzle. After a few minutes you should see the following:

```
more stuff
```

Our program has found a solution which can now be stepped-through by pressing enter:

```
more final stuff
```

Finally, you can also try running our program on the [Try OCAML](https://try.ocamlpro.com/) website. It will be *very* slow, and you'll need to comment-out any `input_line stdin` statements as the site does not appear to support user input. The site will also think that the application is stuck in an infinite loop and attempt to timeout. Simply hit the <kbd>10 seconds!</kbd> button to bump-up the timeout:

![Screenshot](https://github.com/James-P-D/Peg_solitaire/blob/master/tryocamlwebsite.gif)
