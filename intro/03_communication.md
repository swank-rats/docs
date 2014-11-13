## Communication

For the communication we use Websockets. This TCP-based protocol provides bidirectional connections between all stations
of our infrastructure and is well supported by all languages.

### Used Libraries

* Phyton uses the ws4py (Websocket for Phyton) library: https://ws4py.readthedocs.org/en/latest)
* Node-JS uses the minimalistic implementation of Websocket Protocol ws (websocket): https://github.com/einaros/ws
* C++ uses POCO which provides the Websocket implementation: http://pocoproject.org/documentation/index.html 
* JavaScript in Browser uses the nativ Websocket API of the browser

### Protocol

For communication between the stations we use asyncronous json-messages with a specific structure this structure is
implemented for Node.JS in a Open Source module (https://github.com/swank-rats/websocket-wrapper). The implementation
of this module is part of this project.
