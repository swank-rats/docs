#The game logic

##Starting a game
To start a game a defined number of players (in our case two) is needed. This means the first player which gets to the games page will have to choose a color and start a new game. The second one can join the game after choosing a color. This means when no game is ready one has to be created. When a game in the ready status exists, players can join the game as long as the maximum number is reached. When the maximum is reached no player can join the game anymore. For the players which joined it the game will now start.

##During a game
Each player can controll a robot with the arrow keys and he can shoot at the other player(s) by pressing the spacebar. You can find more information about the controlls in the [game controlls](https://github.com/swank-rats/docs/blob/master/game/02_game_controlls.md) section.

###Gameplay
The goal of the game is to reduce the lifepoints of the opponents by shooting him with the cheese bullets. This means when at least two players have lifepoints left the game will continue. The amount of lifepoints and the damage caused by cheesebullets should be configurated in the config-file. Also the multiplicator for fast wins should be configured there.

###Highscore
The final highscore will be calculated from the hits, the needed time and the remaining lifepoints. A highscore will be created for the winner. 

###Connection problems
When one player has problems with it's connection and the connection can not be restored the remaining player winns the game.

##After the game
Is a game finished both players see a message and will then be redirected to the highscore page. The game itself will be set on finished and a new game can be started.
