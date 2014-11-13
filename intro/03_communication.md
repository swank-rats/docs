## Communication

For the communication we use Websockets. This TCP-based protocol provides bidirectional connections between all stations
of our infrastructure and is well supported by all languages.

### Used Libraries

* Phyton uses the [ws4py](https://ws4py.readthedocs.org/en/latest) (Websocket for Phyton) library
* Node-JS uses the minimalistic implementation of Websocket Protocol [ws](https://github.com/einaros/ws) (websocket)
* C++ uses [POCO](http://pocoproject.org/documentation/index.html) which provides the Websocket implementation 
* JavaScript in Browser uses the nativ Websocket API ([Tutorial](http://www.html5rocks.com/de/tutorials/websockets/basics/)) of the browser

### Protocol

For communication between the stations we use asyncronous json-messages with a specific structure this structure is
implemented for Node.JS in a Open Source module [Websocket-Wrapper](https://github.com/swank-rats/websocket-wrapper). The implementation
of this module is part of this project.
