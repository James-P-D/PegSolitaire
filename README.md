# PegSolitaire
[Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire) solver in OCaml

![Screenshot](https://github.com/James-P-D/Peg_solitaire/blob/master/screenshot.gif)

## Details

Peg-Solitaire is a one-player game whereby a number of marbles are placed on a grid with one empty location. The objective of the game is to remove marbles from the grid by jumping existing marbles into empty locations, eventually resulting in a board which contains only one marble. Note that marbles can only jump horizontally and vertically and not diagonally, and that they can only jump over pieces that are immediate neighbours.

For example, given the initial [English Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire#Board) board..

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

..the player could choose to move the marble at `(3, 1)` to `(3, 3)`, which would cause the removal of the marble at `(3, 2)`:

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

Then the player culd move `(5, 2)` to `(3, 2)` which would remove `(4, 2)`:

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

...and so on.

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

However, if we choose wisely, we'll end up with a board like this, which is a winning state:

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

According to [Durango Bill's website](http://www.durangobill.com/Peg33.html#:~:text=The%204%20possible%20legal%20moves,center%20hole%2C%20the%20player%20wins.) there are a huge number of possible games.

## Running

The application has been tested with the [Windows OCaml v 4.10.0](https://ocaml.org/docs/install.html). You can try running it on the [Try OCAML](https://try.ocamlpro.com/) website, but it will be *very* slow, and you'll need to comment-out any `input_line stdin` statements as the site does not appear to support user input.
