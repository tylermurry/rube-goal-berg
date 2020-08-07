const { KafkaClient, Producer } = require('kafka-node');
const app = require('express')();
const wsInstance = require('express-ws')(app);
const WebSocket = require('ws');
const bodyParser = require('body-parser');

const topic = "goal-event"
const partition = 0;
const client = new KafkaClient({ kafkaHost: process.env.KAFKA_HOST });

const producer = new Producer(client);
producer.on('ready', () => {
    console.log('Producer is ready');
});
producer.on('error', error => {
    console.error(error);
});

const processMessage = message => {
    const eventContent = JSON.parse(message);
    eventContent._eventName = 'GoalEvent';

    const event = {
        topic,
        partition,
        messages: JSON.stringify(eventContent),
    };

    producer.send([event], () => {
        console.log('Event published successfully')
    });
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.ws('/events', ws => {
    console.log('Socket connected!');
    ws.on('message', processMessage);
})

app.post('/command', (req, res) => {
    wsInstance.getWss().clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            const command = req.body;
            command._eventName = 'Command'
            client.send(JSON.stringify(command));
        }
    });
    res.sendStatus(200);
})

app.get('/health', (req, res) => res.send('OK'));

app.listen(8080, () => console.log('Listening on :8080'));
