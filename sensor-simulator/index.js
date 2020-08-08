const express = require('express');
const WebSocket = require('ws');
const bodyParser = require('body-parser');

const ws = new WebSocket(process.env.GOAL_DEVICE_SERVICE);
let currentPosition = 0;

ws.on('open', () => {
    console.log('Connection established!');
    ws.on('message', message => {
        const event = JSON.parse(message);
        if (event._eventName === 'Command') {
            if (event.command === 'ChangePosition') {
                console.log(`Processing ChangePosition Command: ${message}`);
                currentPosition = event.position;
            }
        }
    })
})

ws.on('close', () => {
    console.log('Connection closed!');
})

const server = express();
server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());

server.get('/health', (req, res) => res.send('OK'));

server.post('/event', (req, res) => {
    const event = {
        sensorId: 'simulator',
        userId: 'simulated-user',
        dateTime: new Date(),
        madeGoal: req.body.madeGoal,
        position: currentPosition,
    };

    console.log('Sending event');
    console.log(JSON.stringify(event, null, 2));

    ws.send(JSON.stringify(event));
    res.sendStatus(200);
})

server.listen(8080, () => console.log('Listening on :8080'));
