
# Game-Server

The game server is the core component of the swank-rats game and controlls and organizes all the other components and parties in the game.

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
We used the mean stack provided by [mean.io](http://mean.io) because it provides already a lot of the basic needs like a user registration and some demo packages.

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

* W will accelerate the robot and it will drive in the direction it is looking
* S will accelerate the robot and it will drive backwards
* A will rotate the robot to the left
* D will rotate the robot to the right

With the 'L' the player can shoot. As long as the keys are pressed the robot will drive. When no key is pressed the robot will stop. 

## Game logic

1. Starting a game:
   To start a game a defined number of players (in our case two) is needed. This means the first player which gets to the games page will have to choose a color and start a new game. The second one can join the game after choosing a color. This means when no game is ready one has to be created. When a game in the ready status exists, players can join the game as long as the maximum number is reached. When the maximum is reached no player can join the game anymore. For the players which joined it the game will now start.

2. During a game:
   Each player can controll a robot with the keys mentioned above and he can shoot cheese bullets at the other player by pressing the L key. You can find more information about the controlls in the [game controlls](https://github.com/swank-rats/docs/blob/master/game/02_game_controlls.md) section.

  * Gameplay:
    The goal of the game is to reduce the lifepoints of the opponents by shooting him with the cheese bullets. This means when at least two players have lifepoints left the game will continue. The amount of lifepoints and the damage caused by cheesebullets should be configurated in the config-file. Also the multiplicator for fast wins in the highscore calculation should be configured there.

  * Highscore:
    The final highscore will be calculated from the needed time and the remaining lifepoints. A highscore will be created for the winner. 

3. Connection problems:
   With the node module forever the app will be restartet in case of a major error. The connection of the players will be restored when they leave the game-screen and return later. When the connection is lost due to an error the client will also try to restor it.

4. After the game:
   Is a game finished both players see a message and will then be redirected to the highscore page. The game itself will be set on finished and a new game can be started.

Below you can find an image of the general ![lifecycle][lifecycle] of a game.
[lifecycle]: game-server/images/lifecycle.png "Lifecycle of a game"

## Security

To secure the game-server all connections uses SSL and the websockets have to use basic http authentication. Otherwise the connection will be canceled.

## Connecting to the server
All parties conncet to the node.js server via websockets. To register themselves they send 'init' in the cmd-parameter and node server takes care of the rest.

### Robot
When a robot registers himself at the node.js server, its socket-connection gets stored along with some other information like its associated form (square or circle).

```Javascript
init: function(socket, params) {
   if (!!params.form) {
       RobotsSockets[params.form] = {
           socket: socket,
           params: params,
           send: function(msg) {
               ...
               this.socket.send(msg);
               ...
           }
       };
   }
}
```

When a game is gets started all robots will receive a start message which tells the robot that it should execute all moving commands from now on. When a game is ended all robots will receive a end message which indicates that it should not do anything unless he receives a start message again.

### Imageserver
When the image server established the connection it gets also stored in a variable along with some event listerns. The first listener gets called when the socket closes. The second listener gets called when a socket specific error occures.

```Javascript
init: function(socket) {
   ImageServerSocket = socket;

   socket.on('close', function() {
      ...
   }.bind(this));

   socket.on('error', function() {
       ...
   }.bind(this));
}
```

Furthermore the imageserver tells the node server when a player has been hit. Therefore a seperate hit listener exists which needs as parameter the form of the player that was hit and the precicsion to calculate the damage.

Aside from these available listeners the imageserver accepts also a start, stop and a shoot message. The start and stop message work in the same way as for the robots. The shoot message tell the sever that specific player fired a cheese bullet. This will trigger the needed logic and draw a bullet on the images. 

### Client
When a client registers himself on the server, the socket and its related user (username) will be held in a list. Furthermore each client gets assigned a robot at this point. The robots are not defined by a name but by their form (square, circle).

```Javascript
init: function(socket, params) {
   if (!!params.user) {
      ClientSockets[params.user] = socket;
      setRobotSocketForUser(params.user, params.form);
      ...
   }
}
```

Furthermore the client will accept following messages which will trigger an event on the client side:
- __changedStatus__ when a game state has changed
- __hit__ when a player has been hit
- __connectionLost__ when the connection to the image stream has been lost

#### Reestablishing the websocket connection to the server
When a client looses the websocket connection to the server (caused by an error), the client tries to reconnect to the server.

```Javascript
connection.onerror = function(error){
   console.error('Websocket error:',error);
   console.log('Trying to restart websocket...');
   this.init(username, form, wssUrl);
}.bind(this);
```

#### Reestablishing the stream connection
When the client looses its connection to the image stream the image-server will inform the node.js server and he will trigger an action on the client to reconnect (e.g. remove and add the stream-dom-element again).

## Conclusion

### Problems
__mean.io__
mean.io provides a lot of functionallity which was useful, but it also complicated some things like for e.g. the authentication via websockets or extending the user entity. It was not possible to get the session of a user when you do not use mean.io's predifined structure. Furthermore it is also quite complicated to propagate new fields added to a user entity, because somewhere in the code of mean.io some properties of the user object the get cut off. 

These problems could have been solved easier but as mean.io is quite a new framework it has also quite a small community and the resources in the internet are very few. 

Nontheless it was interessting expirience to work with such a technology!
