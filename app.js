const { log } = require('console');
const express=require('express');
// var http=require("http");///extra
const app=express();
const PORT=process.env.PORT || 5000;
const server=app.listen(PORT,()=>
{
    console.log('server is started on',PORT);
});
const io=require('socket.io')(server);

var client={};
io.on('connection', (socket)=>{
    console.log('connected successfully',socket.id);
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




// const express=require("express");
// var http=require("http");
// const app=express();
// const port=process.env.PORT || 5000;
// var server=http.createServer(app);
// var io=require("socket.io")(server);

// app.use(express.json());
// // app.use(cors());
// io.on("connection",(Socket)=>{
//     console.log("connceted");
//     console.log(Socket.id,"has joined");
//     Socket.on("/test",(msg)=>{
//         console.log(msg);
//     })
// });
// server.listen(port,"0.0.0.0",()=>{
//     console.log("server started");
// });