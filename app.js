const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//middlewre
app.use(express.json());
var clients = {};
io.on('connection', (socket)=>{
    console.log('connected',socket.id);
    socket.on("dashboard",(id)=>{
        console.log(id); 
        client[id]=socket;
        console.log(client);
    })
    socket.on('disconnected',(_)=>{
        console.log('disconnected',socket.id);
    });
    socket.on('message',(data)=>{ 
    console.log(data);
    let tergetid=data.reci_id;
    if(client[tergetid])
    client[tergetid].emit('message-recived',data);
    });
});