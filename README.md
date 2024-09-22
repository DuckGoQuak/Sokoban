# Welcome to Sokoban
Soko ban is a puzzle game on a 2-D grid. The grid will contain walls, a box, target, and the player. The goal of the game is the push the box onto the target in the least possible moves. 

# Installation Guide
Open ripes.exe and go the top-left, select File→ Load Program, then find and
load ”starter.s”.

![alt text](https://github.com/DuckGoQuak/Sokoban/blob/main/images/1.jpg)

Then click on the I/O tab on the left (1), if there aren’t already windows
named ”D-Pad 0” and ”LED Matrix 0”, double-click ”LED Matrix” and/or
”D-Pad” under ”Devices” (3).

![alt text](https://github.com/DuckGoQuak/Sokoban/blob/main/images/2.jpg)

In the tab on the right:
- set the width and height of the LED Matrix to 8, and set the LED size as high as preffered (4).
- click and drag the small gray rectangle under ”D-Pad 0” and ”LED Matrix 0” (5) to drag the devices out of their windows.
- click back to the ”Editor” tab on the right (2) and click the fast forward
button to start the game (6).
- To start a new round, click the fast forwardbutton if it is highlighted blue, then the circle made of two arrows and then the fast forward button again (6).

The end result will look something like this, with the console displayed at the
bottom.

![alt text](https://github.com/DuckGoQuak/Sokoban/blob/main/images/3.jpg)

# How to Push a Box
The goal of the game is to push the box onto the target in the minimum
amount of moves

Upon starting the game, the consol will prompt you for the number of players.
The displayed room will contain the player, a box, target, and walls. These
objects are represented by cyan, orange, red, and purple LEDS respectively

![alt text](https://github.com/DuckGoQuak/Sokoban/blob/main/images/4.jpg)

At the start of each player’s turn, a message will display stating the player
number

-By clicking the D-pad window, the play can be controlled with the WASD
keys.
-If the player cannot move in the desired direciton, a message will show
in the console telling the player what is blocking them.
- Each player has a limited amount of time to complete the puzzle, the
remaining time in seconds will display in the consoe every second
- If the player ever wishes to restart, they can move onto the target, doing this
will reset the timer and position of all objects.
- Upon solving the puzzle, the console will a display a message stating ”You
Won! :D ”,
- if they lost they will instead see ”You LOST! D:” as deserved
After the round, the console will display each player along with the amount of
turns they took.
4
