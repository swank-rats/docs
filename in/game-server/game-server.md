
# Game-Server

TODO fancy description of game-server

## Requirements client and server

We defined a platform independent implementation as a general requirement for the client and the game-server. Furthermore we wanted to keep the possibility to play our game also via a tablet or even a smartphone and to keep it also extensible. Last but not least we wanted to use new, state of the art web-technologies for the sake of the web and for our continuing education.

__Client:__
- clean and simple user interface
- the user interface should be responsive by default
- a login / ranking page should be visible for logged in users
- a welcome / introduction / registration page should be visible for all users
- a permanent connection to the server for fast and efficient transfer of game related commands should exist
- the client should be able to display the game universe with it's players and their interactions via a stream


__Server:__
- the server should be able to communicate in an easy/efficient/fast way with the robots, the image processing unit and also the clients (bidirectional communication)
- the server should be able to communicate with a database to persist game results and also player specific data e.g. the user-/player-name, password
- the server should provide a fast webserver which also supports SSL for basic security
- the server has to provide interfaces for the client to process registrations, logins, page-ranking requests and normal page requests as well as game-specific commands
- the server should be able to communicate with the image processing component (more details [here](https://github.com/swank-rats/docs/blob/master/image-processing/02_requirements.md#communication-with-nodejs-server)
- FEATURE: game unrelated users with a smartphone should able to watch the current game on their smartphones. This means that these users should film the game from defined positions with their smartphones and another image will be used as overlay to display player interactions and more

## MEAN-Stack
This stack consists of four different software components which work very smooth with each other. These components are the MongoDB which is a database, the and Express the Angular.js Javascript frameworks and last but not least the Node.js environment.

__MongoDB__
MongoDB (from "humongous") is an open-source document database, and the leading NoSQL database. It's main key features are document-oriented storage, full index support, replication and high availability, auto sharding, map/reduce support, in place updates, and a lot more. You can find more information about the database on their [website](http://www.mongodb.org/).

__Express__
Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications without obscuring Node.js features that you know and love. You can find more information about the framework on their [website](http://expressjs.com/)

__Angular.js__
Angular is an open source framework from Google and helps to make and structure single-page web applications according to the MVC pattern. Angular.js operates entirely on the client side. You can find more information about the framework on their [website](https://angularjs.org/)

__Node.js__
Node.js is an open source, cross-platform runtime environment for Javascript applications. Node.js provides an event-driven, non-blocking I/O model that makes perfect for data-intensive real-time applications. Internally Node.js uses Google V8 Javascript engine which is also used in the Chrome Browsers to execute the applications. A lot of the environment is also written in Javascript and it provides modules for file, socket and HTTP communication which allows it to act as a web server. Popular companies which use Node.js are for example SAP, LinkedIn, Microsoft, Yahoo, Walmart and PayPal. You can find more information about the framework on their [website](http://nodejs.org/)

## Game controls

A robot can be controlled with the arrow keys:
- W will accelerate the robot and it will drive in the direction it is looking
- S will accelerate the robot and it will drive backwards
- A will rotate the robot to the left
- D will rotate the robot to the right

With the 'L' the player can shoot. As long as the keys are pressed the robot will drive. When no key is pressed the robot will stop. 

## Game logic

1. Starting a game:
   To start a game a defined number of players (in our case two) is needed. This means the first player which gets to the games page will have to choose a color and start a new game. The second one can join the game after choosing a color. This means when no game is ready one has to be created. When a game in the ready status exists, players can join the game as long as the maximum number is reached. When the maximum is reached no player can join the game anymore. For the players which joined it the game will now start.

2. During a game:
   Each player can controll a robot with the keys mentioned above and he can shoot cheese bullets at the other player by pressing the L key. You can find more information about the controlls in the [game controlls](https://github.com/swank-rats/docs/blob/master/game/02_game_controlls.md) section.

  * Gameplay:
    The goal of the game is to reduce the lifepoints of the opponents by shooting him with the cheese bullets. This means when at least two players have lifepoints left the game will continue. The amount of lifepoints and the damage caused by cheesebullets should be configurated in the config-file. Also the multiplicator for fast wins should be configured there.

  * Highscore:
    The final highscore will be calculated from the needed time and the remaining lifepoints. A highscore will be created for the winner. 

3. Connection problems:
   With the node module forever the app will be restartet in case of a major error. The connection of the players will be restored when they leave the game-screen and return later. When the connection is lost due to an error the client will also try to restor it.

4. After the game:
   Is a game finished both players see a message and will then be redirected to the highscore page. The game itself will be set on finished and a new game can be started.
