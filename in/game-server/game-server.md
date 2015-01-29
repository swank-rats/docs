
# Game server

The game server is the core component of the Swank-Rats game and controls and organizes all the other components and parties in the game.

## Requirements client and server

We defined a platform independent implementation as a general requirement for the client and the game server. Furthermore we wanted to keep the possibility to play our game also via a tablet or even a smartphone and to keep it extensible. Last but not least we wanted to use new, state of the art web-technologies for the sake of the web and for our continuing education.

__Client:__
- Clean and simple user interface
- The user interface should be responsive by default
- A login / ranking page should be visible for logged in users
- A welcome / introduction / registration page should be visible for all users
- A permanent connection to the server for fast and efficient transfer of game related commands should exist
- The client should be able to display the game universe with it's players and their interactions via a stream


__Server:__
- The server should be able to communicate in an easy / efficient / fast way with the robots, the image processing unit and also the clients (bidirectional communication)
- The server should be able to communicate with a database to persist game results and also player specific data e.g. the user-/player-name, password
- The server should provide a fast web server which also supports SSL for basic security
- The server has to provide interfaces for the client to process registrations, logins, page-ranking requests and normal page requests as well as game-specific commands
- the server should be able to communicate with the image processing component (more details [here](https://github.com/swank-rats/docs/blob/master/image-processing/02_requirements.md#communication-with-nodejs-server)
- FEATURE: game unrelated users with a smartphone should able to watch the current game on their smartphones. This means that these users should film the game from defined positions with their smartphones and another image will be used as overlay to display player interactions and more

## MEAN stack
We used the MEAN stack provided by [MEAN.IO](http://mean.io) because it provides already a lot of the basic needs like a user registration and some demo packages.

This stack consists of four different software components which work very smooth with each other. The components are MongoDB, which is a database, Express, the Angular.js JavaScript frameworks, and last the Node.js environment.

__MongoDB__
MongoDB (from "humongous") is an open source document database, and the leading NoSQL database. It's main key features are document-oriented storage, full index support, replication and high availability, auto sharding, map/reduce support, in place updates, and a lot more. You can find more information about the database on their [website](http://www.mongodb.org/).

__Express__
Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications without obscuring Node.js features that you know and love. You can find more information about the framework on their [website](http://expressjs.com/)

__Angular.js__
Angular is an open source framework from Google and helps to make and structure single-page web applications according to the MVC pattern. Angular.js operates entirely on the client side. You can find more information about the framework on their [website](https://angularjs.org/)

__Node.js__
Node.js is an open source, cross-platform runtime environment for JavaScript applications. Node.js provides an event-driven, non-blocking I/O model that makes perfect for data-intensive real-time applications. Internally Node.js uses Google V8 JavaScript engine which is also used in the Chrome Browsers to execute the applications. A lot of the environment is also written in JavaScript and it provides modules for file, socket and HTTP communication which allows it to act as a web server. Popular companies which use Node.js are for example SAP, LinkedIn, Microsoft, Yahoo, Walmart and PayPal. You can find more information about the framework on their [website](http://nodejs.org/)

## Game controls

A robot can be controlled with the keys:

* W: will accelerate the robot and it will drive in the direction it is looking
* S: will accelerate the robot and it will drive backwards
* A: will rotate the robot to the left
* D: will rotate the robot to the right

With the 'L' the player can shoot. As long as the keys are pressed the robot will drive. When no key is pressed the robot will stop. 

## Game logic

1. Starting a game:
   To start a game a defined number of players (in our case two) is needed. This means the first player which gets to the games page will have to choose a color and start a new game. The second one can join the game after choosing a color. This means when no game is ready one has to be created. When a game in the ready status exists, players can join the game as long as the maximum number is reached. When the maximum is reached no player can join the game anymore. For the players which joined it the game will now start.

2. During a game:
   Each player can control a robot with the keys mentioned above and he can shoot cheese bullets at the other player by pressing the L key. You can find more information about the controls in the game controls section.

  * Gameplay:
    The goal of the game is to reduce the lifepoints of the opponents by shooting him with the cheese bullets. This means when at least two players have lifepoints left the game will continue. The amount of lifepoints and the damage caused by cheese-bullets should be configured in a config-file. Also the multiplicator for fast wins in the highscore calculation should be configured there.

  * Highscore:
    The final highscore will be calculated from the needed time and the remaining lifepoints. A highscore will be created for the winner. 

3. Connection problems:
   With the node module forever the app will be restarted in case of a major error. The connection of the players will be restored when they leave the game-screen and return later. When the connection is lost due to an error the client will also try to restore it.

4. After the game:
   Is a game finished both players see a message and will then be redirected to the highscore page. The game itself will be set on finished and a new game can be started.

Below you can find an image of the general lifecycle of a game.

![Lifecycle of a game][game-server/images/lifecycle.png]

## Security

To secure the game server all connections use SSL and the WebSockets have to use basic HTTP authentication. Otherwise the connection will be cancelled. You can find more information about the communication and its security in the communication section.

## Connecting to the server
All parties connect to the Node.js server via WebSockets. To register themselves they send 'init' in the cmd-parameter and node server takes care of the rest.

### Robot
When a robot registers himself at the Node.js server, its socket-connection gets stored along with some other information like its associated form (square or circle).

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

When a game gets started all robots will receive a start message which tells the robots that they should execute all moving commands from now on. When a game is finished all robots will receive a stop message which indicates that they should not do anything unless they receive a start message again.

### Image processing server
When the image processing server established the connection is stored in a variable along with some event listeners. The first listener gets called when the socket closes. The second listener gets called when a socket specific error occurs.

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

Furthermore the image processing server tells the Node.js server when a player has been hit. Therefore a separate hit listener exists which gets the form of the hit  and the precision passed as parameters. The precision is used to calculate the damage done by the shot.

Aside from those available listeners the image processing server accepts also a start, a stop and a shoot message. The start and stop message work in the same way as for the robots. The shoot message tells the image processing server that a specific player fired a cheese-bullet. This will trigger the needed logic and draw a bullet on the live stream. 

### Client
When a client registers himself on the server, the socket and its related user will be held in a list. Furthermore each client gets assigned to a robot. The robots are not defined by a name but by their form (e.g square, circle).

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

#### Re-establishing the WebSocket connection to the server
When a client looses the WebSocket connection to the server (caused by an error), the client tries to reconnect to the server.

```Javascript
connection.onerror = function(error){
   console.error('Websocket error:',error);
   console.log('Trying to restart websocket...');
   this.init(username, form, wssUrl);
}.bind(this);
```

#### Re-establishing the stream connection
When the client looses its connection to the live stream the image processing server will inform the Node.js server and he will trigger an action on the client to reconnect (e.g. remove and add the stream-dom-element again).

## Problems
### MEAN.IO
MEAN.IO provides a lot of functionality which was useful, but it also complicated some things like e.g. the authentication via WebSockets or extending the user entity. It was not possible to get the session of a user when you do not use MEAN.IO's predefined structure. Furthermore it is also quite complicated to propagate new fields added to a user entity, because somewhere in the code of MEAN.IO some properties of the user object the get cut off. 

These problems could have been solved easier but as MEAN.IO is quite a new framework it has also quite a small community and the resources in the internet are very few. 

### Certificate
Another problem was the certificate for the SSL connection. The different parties had different strict rules when to accept an SSL certificate. For example the Python implementation did not need a FQDN in the certificate but the image processing server (the used library was POCO) needed a FQDN or at least an IP address to accept the certificate. So it was not such a big problem but you have to know this. Otherwise you keep wondering why one party accepts the certificate and the other just declines it without telling you why.


## Conclusion
Nonetheless it was interesting experience to work with such technologies!
