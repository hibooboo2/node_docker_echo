"strict";

var hostAddress;
require('dns').lookup(require('os').hostname(), function (err, add, fam) {
  hostAddress = add;
})

var http = require('http');
http.createServer(function (req, res) {
    res.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    res.end('Hello from '+ hostAddress +'\n');
    console.log("Ping from "+ req.url);
}).listen(8000);