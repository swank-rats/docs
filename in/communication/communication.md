
# Communication

For the communication the system uses Websocket on all stations. The protocol we use is self-defined and for designed
for our usage. But it is fully unit tested and it will provided by npm for third party usage.

## Websockets

Websockets is a tcp based protocol which provides a bidirectional connection between a client and a server.
Originally it is developed for real-time communication between web-server and browser.

Websockets uses the Upgrade mechanism of HTTP 1.1.

### Handshake

Before a Websocket Connection will be opened a HTTP request will be executed.

![Websocket handshake](http://presentation.asapo.at/websocket/img/websocket.png)

The request is nearly normal HTTP but there are some additional headers.

```
GET /socket HTTP/1.1
Host: thirdparty.com
Origin: http://example.com
Connection: Upgrade
Upgrade: websocket
Sec-WebSocket-Version: 13
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Protocol: chat
Sec-WebSocket-Extensions: x-webkit-deflate-message, x-custom-extension
```

__Connection: Upgrade and Upgrade: websocket__
Request to perform an upgrade to Websocket protocol

__Sec-WebSocket-Version: 13__
WebSocket protocol version used by the client

__Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==__
Auto-generated key to verify server protocol support

__Sec-WebSocket-Protocol: chat__
Optional list of subprotocols specified by the application

__Sec-WebSocket-Extensions: ...__
Optional list of extensions specified by the server

The server send a response with status-code `101: Switching Protocols`.

```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Access-Control-Allow-Origin: http://example.com
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
Sec-WebSocket-Protocol: chat
Sec-WebSocket-Extensions: x-custom-extension
```

The connection stays open and the server or client can send over the open tcp connections.

### Data protocol

The data is minimally framed, with a small header followed by payload. WebSocket transmissions are described as
"messages", where a single message can optionally be split across several data frames.
<http://en.wikipedia.org/wiki/WebSocket> The receiver will be informed after receiving a full message.

Full description under [http://presentation.asapo.at/websocket](http://presentation.asapo.at/websocket)

## Application protocol

The defined protocol uses json-encoded objects. These objects can be send in UTF-8 strings. The protocol and the
library are able to delegate messages to a defined handler. The listener will defined in the property `to`. The
property `cmd` defines which function will be called for the given listener.

__Example Message:__

```javascript
{
    to: 'test',
    cmd: 'echo',
    params: {
        toUpper: true
    },
    data: 'testdata'
}
```

__Example Listener:__

```javascript
var echoListener = {
    echo: function(socket, params, data) {
    	if (!!params.toUpper) {
    	    data = data.toUpperCase();
    	}
        socket.send(data);
    }
};
websocketServer('test', echoListener);
```

__CLIENT (wscat):__
```bash
wscat --connection localhost:8080
> {"to":"test", "cmd":"echo", "params":{"toUpper":true}, "data":"testdata"}
  TESTDATA
```

The example describes how the messages and the listener should be structured.

__Properties:__

* to: used to find listener on the server
* cmd: command name to find function name in listener
* params & data: will be passed to the function

__Remark:__ If no `cmd` is defined a `default` callback on the listener is called.

The communication library is only full implemented for the node.js server. The clients uses the raw JSON-string.
