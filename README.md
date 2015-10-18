# SailConnect4

The famous [Connect4](https://en.wikipedia.org/wiki/Connect_Four) game, written in Qml/Qt/C++.

Implemented for desktop and [Sailfish OS](https://sailfishos.org/) using [Silica](https://sailfishos.org/develop/docs/silica/).

You can play human vs IA, human vs human or IA vs IA (for fun!)

## IA

There is a strong IA using a minimax search tree with alpha-beta pruning, and fast and accurate heuristic computation.

There are 5 levels for IA force.

The IA configures its strategie itself at each beginning of game or after config change, to avoid doing the sames plays every time. Depending of force, random takes part of IA decision.
You can play against it without being boring !



*Licence: GPL
Author: Louis-Joseph Fournier
First release date: 2015-10-18*
